import "package:chewie/chewie.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki_core/model.dart";
import "package:video_player/video_player.dart";

class VideoAttachmentWidget extends StatefulWidget {
  const VideoAttachmentWidget({
    required this.attachment,
    super.key,
  });

  final Attachment attachment;

  @override
  State<VideoAttachmentWidget> createState() => _VideoAttachmentWidgetState();
}

class _VideoAttachmentWidgetState extends State<VideoAttachmentWidget> {
  late VideoPlayerController _videoController;
  late Future<ChewieController> _chewieControllerFuture;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(widget.attachment.url);
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
          return const Center(
            child: Text("Couldn't load video"),
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
      looping: true,
    );
  }
}
