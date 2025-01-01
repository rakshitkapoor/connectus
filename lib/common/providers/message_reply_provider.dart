import 'package:connectus/common/enums/message_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply{
  final String message;
  final bool isMe;
  final MessageEnums messageEnums;

  MessageReply(this.message,this.isMe,this.messageEnums);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null); 