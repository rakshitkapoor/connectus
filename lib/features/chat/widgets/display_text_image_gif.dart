import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectus/common/enums/message_enums.dart';
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
        : CachedNetworkImage(imageUrl: message);
  }
}
