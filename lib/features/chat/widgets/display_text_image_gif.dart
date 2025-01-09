import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectus/common/enums/message_enums.dart';
import 'package:connectus/features/chat/widgets/audio_player.dart';
import 'package:connectus/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnums type;

  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {

    return type == MessageEnums.text
        ? Text(message, style: const TextStyle(fontSize: 16))
        : type == MessageEnums.audio
        ? AudioPlayerWidget(audioUrl: message,)
        : type == MessageEnums.video
        ? VideoPlayerItem(videoUrl: message)
        : CachedNetworkImage(imageUrl: message);
  }
}
