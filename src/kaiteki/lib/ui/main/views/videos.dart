import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:tuple/tuple.dart';
import 'package:video_player/video_player.dart';

typedef _PostAttachmentCompound = Tuple2<Post, Attachment>;

class VideoMainScreenView extends ConsumerStatefulWidget {
  const VideoMainScreenView({super.key});

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
    controller = StreamController();
  }

  Future<void> requestNextPage() async {
    List<Post> posts;

    var attempts = 0;
    do {
      if (attempts >= 5) {
        final message =
            "Giving up after $attempts attempt(s) - your timeline has no matching posts";
        log(message, name: "FilteredTimelineStream");
        controller.addError(Exception(message));
        return;
      }

      controller.add(null);

      try {
        posts = await adapter.getTimeline(
          timelineKind,
          query: TimelineQuery(untilId: _lastId, onlyMedia: onlyMedia),
        );

        if (posts.isEmpty) {
          log("Received no posts", name: "FilteredTimelineStream");
          attempts++;
          break;
        }

        _lastId = posts.last.id;

        final filter = this.filter;
        if (filter != null) posts = posts.where(filter).toList();

        if (posts.isEmpty) {
          log(
            "${posts.length} posts match the filter",
            name: "FilteredTimelineStream",
          );
          attempts++;
          continue;
        }

        log("Loaded ${posts.length} posts", name: "FilteredTimelineStream");
      } catch (e, s) {
        if (!controller.isClosed) controller.addError(e, s);
        return;
      }
    } while (posts.isEmpty);

    controller.add(this.posts..addAll(posts));
    log(
      "Contain ${this.posts.length} posts now",
      name: "FilteredTimelineStream",
    );
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
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white, shadows: shadows),
                child: StreamBuilder<Iterable<Post>?>(
                  stream: _stream!.stream,
                  builder: (context, snapshot) {
                    final loadingWidget = Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Fetching the next post, hang tight...",
                          ),
                        ],
                      ),
                    );

                    if (snapshot.hasError) {
                      return ErrorLandingWidget.fromAsyncSnapshot(
                        snapshot,
                        onRetry: _stream!.requestNextPage,
                      );
                    }

                    if (snapshot.data == null) return loadingWidget;

                    final posts = snapshot.data?.expand(
                      (p) {
                        return p.attachments!
                            .map((a) => _PostAttachmentCompound(p, a));
                      },
                    ).toList();

                    final _PostAttachmentCompound? compound;

                    if (posts != null && (posts.length - 1) >= _index) {
                      compound = posts.elementAt(_index);
                    } else {
                      compound = null;
                    }

                    final post = compound?.item1;

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

                            if (compound == null) return loadingWidget;

                            return Positioned.fill(
                              child: _VideoWidget(
                                Uri.parse(compound.item2.url),
                                key: ValueKey(compound.item2.url),
                                onProgressChanged: (v) => setState(
                                  () => progress = v,
                                ),
                              ),
                            );
                          },
                          onPageChanged: (i) {
                            setState(() => _index = i);

                            final notEnoughPages =
                                _index > snapshot.data!.length - 1;
                            if (notEnoughPages) {
                              _stream!.requestNextPage();
                            }
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            const SizedBox(height: 8),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.star_outline_rounded,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.repeat_rounded,
                                              ),
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
      ),
    );
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
    _videoController.addListener(() {
      final duration = _videoController.value.duration.inMicroseconds;
      final position = _videoController.value.position.inMicroseconds;
      widget.onProgressChanged?.call(position / duration);
    });
  }

  @override
  void dispose() {
    widget.onProgressChanged?.call(null);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController.value.isBuffering) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      ),
    );
  }
}
