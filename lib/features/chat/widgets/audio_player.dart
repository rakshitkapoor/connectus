import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerComplete.listen((_) {
      setState(() => isPlaying = false);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints(minWidth: 200),
      onPressed: () async {
        if (isPlaying) {
          await audioPlayer.pause();
        } else {
          await audioPlayer.play(UrlSource(widget.audioUrl));
        }
        setState(() => isPlaying = !isPlaying);
      },
      icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
    );
  }
}