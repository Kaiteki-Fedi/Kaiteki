import "dart:io";

import "package:chewie/chewie.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:video_player/video_player.dart";

import "media.dart";

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    required this.controller,
    this.looping = false,
    super.key,
  });

  factory VideoPlayer.fromMedia(Media media) {
    return VideoPlayer(
      controller: switch (media) {
        RemoteMedia() => VideoPlayerController.networkUrl(media.url),
        LocalMedia() => VideoPlayerController.file(File(media.file.path)),
      },
    );
  }

  final bool looping;
  final VideoPlayerController controller;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _videoController;
  late Future<ChewieController> _chewieControllerFuture;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // FIXME(Craftplacer): Reinit controllers on change
    _videoController = widget.controller;
    _chewieControllerFuture = _prepareChewie();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChewieController>(
      future: _chewieControllerFuture,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is UnimplementedError) {
            return Center(
              child: Text("Video playback is not supported on this platform."),
            );
          }
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (!snapshot.hasData) {
          return centeredCircularProgressIndicator;
        } else {
          return Chewie(controller: snapshot.data!);
        }
      },
    );
  }

  Future<ChewieController> _prepareChewie() async {
    await _videoController.initialize();

    return _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoInitialize: true,
      looping: true,
    );
  }
}
