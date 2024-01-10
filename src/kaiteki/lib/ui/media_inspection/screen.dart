import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:url_launcher/url_launcher.dart";

import "../media/media.dart";
import "../media/media_preview.dart";

class MediaInspectionScreen extends StatefulWidget {
  final List<Media> media;
  final Post? post;
  final int? initialIndex;

  const MediaInspectionScreen({
    super.key,
    required this.media,
    this.post,
    this.initialIndex,
  });

  factory MediaInspectionScreen.fromPost(
    Post post, {
    int? initialIndex,
  }) {
    final attachments = post.attachments;
    assert(attachments != null || attachments!.isNotEmpty);
    return MediaInspectionScreen(
      post: post,
      media: attachments!.map(RemoteMedia.fromAttachment).toList(),
      initialIndex: initialIndex,
    );
  }

  @override
  State<MediaInspectionScreen> createState() => _MediaInspectionScreenState();
}

enum _OverflowMenuAction {
  openInBrowser,
}

class _MediaInspectionScreenState extends State<MediaInspectionScreen> {
  bool _immerse = false;

  // bool _showThread = false;
  int _currentPage = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: widget.initialIndex ?? 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPaginationButtons = !_immerse && widget.media.length > 1;
    final canGoBack = _currentPage > 0;
    final canGoForward = _currentPage < widget.media.length - 1;

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PreviousPageIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
        const CharacterActivator("h"): const PreviousPageIntent(),
        const CharacterActivator("l"): const NextPageIntent(),
      },
      child: Row(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: _immerse
                  ? null
                  : AppBar(
                      actions: [
                        // Disabling post sidebar until it is properly implemented
                        // if (widget.post != null)
                        //   IconButton(
                        //     onPressed: () =>
                        //         setState(() => _showThread = !_showThread),
                        //     icon: Icon(
                        //       _showThread
                        //           ? Icons.view_stream
                        //           : Icons.view_stream_outlined,
                        //     ),
                        //     tooltip: "Show thread",
                        //   ),
                        PopupMenuButton(
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: _OverflowMenuAction.openInBrowser,
                              child: Text(context.l10n.openInBrowserLabel),
                            ),
                          ],
                          onSelected: (action) async {
                            switch (action) {
                              case _OverflowMenuAction.openInBrowser:
                                final remoteMedia =
                                    widget.media[_currentPage] as RemoteMedia;
                                await launchUrl(remoteMedia.url);
                                break;
                            }
                          },
                        ),
                      ],
                      foregroundColor: switch (Theme.of(context).brightness) {
                        Brightness.dark => null,
                        Brightness.light =>
                          Theme.of(context).colorScheme.inverseOnSurface,
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.scrim.withOpacity(.5),
                      // surface tinting on transparent surfaces looks bad
                      surfaceTintColor: Colors.transparent,
                      elevation: 8.0,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: context.materialL10n.closeButtonLabel,
                      ),
                      title: Text("${_currentPage + 1}/${widget.media.length}"),
                    ),
              body: Actions(
                actions: <Type, Action<Intent>>{
                  PreviousPageIntent: CallbackAction<PreviousPageIntent>(
                    onInvoke: (_) => _onPreviousPage(),
                  ),
                  NextPageIntent: CallbackAction<NextPageIntent>(
                    onInvoke: (_) => _onNextPage(),
                  ),
                },
                child: Consumer(
                  child: Focus(
                    autofocus: true,
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      children: [
                        for (final media in widget.media)
                          MediaPreview(
                            media,
                            onTapImage: () {
                              setState(() => _immerse = !_immerse);
                            },
                          ),
                      ],
                    ),
                  ),
                  builder: (context, ref, child) {
                    var label = context.materialL10n.tabLabel(
                      tabIndex: _currentPage + 1,
                      tabCount: widget.media.length,
                    );

                    final currentMedia = widget.media[_currentPage];

                    if (currentMedia.description != null) {
                      label += ". ${currentMedia.description}";
                    }

                    print(label);

                    final needsPaginationButtons =
                        ref.watch(pointingDeviceProvider) ==
                            PointingDevice.mouse;
                    final showBackButton = showPaginationButtons &&
                        needsPaginationButtons &&
                        canGoBack;
                    final showForwardButton = showPaginationButtons &&
                        needsPaginationButtons &&
                        canGoForward;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Semantics(
                          liveRegion: true,
                          onIncrease: () => Actions.invoke(
                            context,
                            const NextPageIntent(),
                          ),
                          onDecrease: () => Actions.invoke(
                            context,
                            const PreviousPageIntent(),
                          ),
                          label: label,
                          child: child,
                        ),
                        Positioned(
                          left: 8,
                          child: AnimatedOpacity(
                            opacity: showBackButton ? 1 : 0,
                            duration: Durations.short2,
                            child: IgnorePointer(
                              ignoring: !showBackButton,
                              child: _PaginationFab(
                                onPressed: () => Actions.invoke(
                                  context,
                                  const PreviousPageIntent(),
                                ),
                                tooltip:
                                    context.materialL10n.previousPageTooltip,
                                child: const Icon(Icons.chevron_left_rounded),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          child: AnimatedOpacity(
                            opacity: showForwardButton ? 1 : 0,
                            duration: Durations.short2,
                            child: IgnorePointer(
                              ignoring: !showForwardButton,
                              child: _PaginationFab(
                                onPressed: () => Actions.invoke(
                                  context,
                                  const NextPageIntent(),
                                ),
                                tooltip: context.materialL10n.nextPageTooltip,
                                child: const Icon(Icons.chevron_right_rounded),
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
          // if (widget.post != null && _showThread)
          //   SizedBox(
          //     width: 500,
          //     child: ConversationScreen(
          //       widget.post!.id,
          //     ),
          //   ),
        ],
      ),
    );
  }

  void _onNextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPreviousPage() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _PaginationFab extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget child;

  const _PaginationFab({
    this.onPressed,
    this.tooltip,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fabBackgroundColor = switch (theme.colorScheme.brightness) {
      Brightness.dark => theme.colorScheme.inverseSurface,
      Brightness.light => theme.colorScheme.surface,
    };

    final fabForegroundColor = switch (theme.colorScheme.brightness) {
      Brightness.dark => theme.colorScheme.inverseOnSurface,
      Brightness.light => theme.colorScheme.onSurface,
    };

    return Focus(
      skipTraversal: true,
      canRequestFocus: false,
      descendantsAreFocusable: false,
      child: Semantics(
        excludeSemantics: true,
        child: FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: fabBackgroundColor,
          foregroundColor: fabForegroundColor,
          tooltip: tooltip,
          child: child,
        ),
      ),
    );
  }
}
