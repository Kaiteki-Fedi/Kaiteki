import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:video_player/video_player.dart';

class VideoAttachmentWidget extends StatefulWidget {
  const VideoAttachmentWidget({
    required this.attachment,
    Key? key,
  }) : super(key: key);

  final Attachment attachment;

  @override
  _VideoAttachmentWidgetState createState() => _VideoAttachmentWidgetState();
}

class _VideoAttachmentWidgetState extends State<VideoAttachmentWidget> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.attachment.url);
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
      future: _prepareChewie(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Chewie(controller: snapshot.data!);
        }
      },
    );
  }

  Future<ChewieController> _prepareChewie() async {
    if (_chewieController != null) return _chewieController!;

    await _videoController.initialize();

    return _chewieController = ChewieController(
      videoPlayerController: _videoController,
      looping: true,
    );
  }
}
