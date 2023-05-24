import "dart:async";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/text/rendering_extensions.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:logging/logging.dart";
import "package:video_player/video_player.dart";

typedef _PostAttachmentCompound = (Post, Attachment);

class VideoMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function(MainScreenViewType view) onChangeView;

  const VideoMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<VideoMainScreenView> createState() =>
      _VideoMainScreenViewState();
}

class FilteredTimelineStream {
  late StreamController<Iterable<Post>?> controller;
  final BackendAdapter adapter;
  final TimelineKind timelineKind;
  final bool Function(Post post)? filter;
  final bool onlyMedia;

  static final _logger = Logger("FilteredTimelineStream");

  List<Post> posts = [];
  String? _lastId;

  Stream<Iterable<Post>?> get stream => controller.stream;

  void dispose() {
    controller.close();
  }

  FilteredTimelineStream(
    this.adapter,
    this.timelineKind, {
    this.filter,
    this.onlyMedia = false,
  }) {
    controller = StreamController.broadcast();
  }

  Future<void> requestNextPage() async {
    List<Post> posts;

    var attempts = 0;
    do {
      if (attempts >= 5) {
        _logger.warning("Giving up after $attempts attempt(s)");
        controller.addError(
          Exception(
            "Hmm... your timeline seems a bit empty of content, check back later again!",
          ),
        );
        return;
      }

      controller.add(null);

      try {
        posts = await adapter.getTimeline(
          timelineKind,
          query: TimelineQuery(untilId: _lastId, onlyMedia: onlyMedia),
        );

        if (posts.isEmpty) {
          _logger.fine("Received no posts");
          attempts++;
          break;
        }

        _lastId = posts.last.id;

        final filter = this.filter;
        if (filter != null) posts = posts.where(filter).toList();

        if (posts.isEmpty) {
          _logger.fine("${posts.length} posts match the filter");
          attempts++;
          continue;
        }

        _logger.fine("Loaded ${posts.length} posts");
      } catch (e, s) {
        if (!controller.isClosed) controller.addError(e, s);
        return;
      }
    } while (posts.isEmpty);

    controller.add(this.posts..addAll(posts));
    _logger.fine("Contain ${this.posts.length} posts now");
  }
}

class _VideoMainScreenViewState extends ConsumerState<VideoMainScreenView> {
  int _index = 0;
  FilteredTimelineStream? _stream;
  double? progress;

  @override
  void initState() {
    super.initState();
    ref.listenManual<BackendAdapter>(
      adapterProvider,
      (previous, next) {
        _stream?.dispose();

        _stream = FilteredTimelineStream(
          next,
          TimelineKind.federated,
          onlyMedia: true,
          filter: (p) {
            return p.attachments?.isNotEmpty == true &&
                p.attachments!.any((a) => a.type == AttachmentType.video);
          },
        )..requestNextPage();

        if (previous != null) setState(() {});
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    const shadows = <Shadow>[
      Shadow(blurRadius: 1),
      Shadow(blurRadius: 3, offset: Offset(0, 1)),
    ];

    return Theme(
      data: context.findAncestorWidgetOfExactType<MaterialApp>()!.darkTheme!,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white, shadows: shadows),
              child: StreamBuilder<Iterable<Post>?>(
                stream: _stream!.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorLandingWidget.fromAsyncSnapshot(
                      snapshot,
                      onRetry: _stream!.requestNextPage,
                    );
                  }

                  if (snapshot.data == null) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          circularProgressIndicator,
                          SizedBox(height: 16),
                          Text(
                            "Fetching the next post, hang tight...",
                          ),
                        ],
                      ),
                    );
                  }

                  final posts = snapshot.data
                      ?.expand(
                        (p) => p.attachments!.map((a) => (p, a)),
                      )
                      .toList();

                  final _PostAttachmentCompound? compound;

                  if (posts != null && (posts.length - 1) >= _index) {
                    compound = posts.elementAt(_index);
                  } else {
                    compound = null;
                  }

                  final post = compound?.$1;

                  return Stack(
                    children: [
                      PageView.builder(
                        itemCount: (posts?.length ?? 0) + 1,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final _PostAttachmentCompound? compound;

                          if (posts != null && (posts.length - 1) >= _index) {
                            compound = posts.elementAt(_index);
                          } else {
                            compound = null;
                          }

                          if (compound == null) {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  circularProgressIndicator,
                                  SizedBox(height: 16),
                                  Text(
                                    "Fetching the next post, hang tight...",
                                  ),
                                ],
                              ),
                            );
                          }

                          return _VideoWidget(
                            compound.$2.url,
                            key: ValueKey(compound.$2.url),
                            onProgressChanged: (v) {
                              if (mounted) {
                                setState(
                                  () => progress = v,
                                );
                              }
                            },
                          );
                        },
                        onPageChanged: (i) => _onPageChanged(i, snapshot),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      ),
                      IconTheme(
                        data: const IconThemeData(
                          color: Colors.white,
                          size: 36,
                          shadows: shadows,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: post == null
                                ? null
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post.author.handle.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (post.content != null)
                                              Text.rich(
                                                post.renderContent(
                                                  context,
                                                  ref,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.more_horiz_rounded,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          AvatarWidget(
                                            post.author,
                                            size: 36,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int i, AsyncSnapshot<Iterable<Post>?> snapshot) {
    setState(() => _index = i);

    final notEnoughPages = _index > snapshot.data!.length - 1;
    if (notEnoughPages) {
      _stream!.requestNextPage();
    }
  }
}

class _VideoWidget extends StatefulWidget {
  final Uri url;
  final Function(double? progress)? onProgressChanged;

  const _VideoWidget(this.url, {super.key, this.onProgressChanged});

  @override
  State<_VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<_VideoWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.url.toString());
    _videoController.initialize().then((_) {
      _videoController.play();
      setState(() {});
    });
    _videoController.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    final duration = _videoController.value.duration.inMicroseconds;
    final position = _videoController.value.position.inMicroseconds;
    widget.onProgressChanged?.call(position / duration);
  }

  @override
  void dispose() {
    widget.onProgressChanged?.call(null);
    _videoController
      ..removeListener(_onVideoUpdate)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController.value.isBuffering) {
      return centeredCircularProgressIndicator;
    }

    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: VideoPlayer(_videoController),
    );
  }
}
