import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerPlusController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.videoUrl),
        invalidateCacheIfOlderThan: const Duration(days: 69)
      )
      ..initialize().then((val) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: Stack(
        children: [
          CachedVideoPlayerPlus(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(isPlay ? Icons.pause_circle : Icons.play_circle ,size: 50,color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
