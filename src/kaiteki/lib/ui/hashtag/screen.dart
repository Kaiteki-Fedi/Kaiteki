import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/widget.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class HashtagScreen extends ConsumerStatefulWidget {
  final String hashtag;

  const HashtagScreen(this.hashtag, {super.key});

  @override
  ConsumerState<HashtagScreen> createState() => _HashtagScreenState();
}

class _HashtagScreenState extends ConsumerState<HashtagScreen> {
  bool? _isFollowing;
  Future? _followFuture;

  @override
  void initState() {
    super.initState();

    _fetchHashtag();
  }

  @override
  Widget build(BuildContext context) {
    final supportsFollowingHashtags = ref.watch(
      adapterProvider.select(
        (adapter) =>
            adapter.capabilities
                .safeCast<HashtagSupportCapabilities>()
                ?.supportsFollowingHashtags ==
            true,
      ),
    );

    final followButton = FutureBuilder(
      future: _followFuture,
      builder: (context, snapshot) {
        return TextButton(
          onPressed: _isFollowing == null ||
                  snapshot.connectionState == ConnectionState.active
              ? null
              : _onFollow,
          child: _isFollowing == true
              ? const Text("Unfollow")
              : const Text("Follow"),
        );
      },
    );
    final closeButton = IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: closeButton,
        // ignore: l10n
        title: Text("#${widget.hashtag}"),
        forceMaterialTransparency: true,
        actions: [if (supportsFollowingHashtags) followButton],
      ),
      body: Timeline(HashtagTimelineSource(widget.hashtag), maxWidth: 600),
    );
  }

  Future<void> _onFollow() async {
    final messenger = ScaffoldMessenger.of(context);
    final hashtag = widget.hashtag;

    final isFollowing = _isFollowing;

    if (isFollowing == null) return;

    final hashtags = ref.read(adapterProvider).safeCast<HashtagSupport>();

    if (hashtags == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("This instance does not support following hashtags."),
        ),
      );
      return;
    }

    setState(() {
      final future = isFollowing
          ? hashtags.unfollowHashtag(hashtag)
          : hashtags.followHashtag(hashtag);

      _followFuture = future.then(
        (_) {
          setState(() => _isFollowing = !isFollowing);

          messenger.showSnackBar(
            SnackBar(
              content: Text(
                _isFollowing == true
                    ? "Followed #$hashtag"
                    : "Unfollowed #$hashtag",
              ),
            ),
          );
        },
        onError: (error) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Failed to follow hashtag")),
          );
        },
      );
    });
  }

  Future<void> _fetchHashtag() async {
    final hashtags = ref.read(adapterProvider).safeCast<HashtagSupport>();

    if (hashtags == null) return;

    final hashtag = await hashtags.getHashtag(widget.hashtag);
    setState(() => _isFollowing = hashtag.isFollowing);
  }
}
