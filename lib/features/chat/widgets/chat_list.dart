import 'package:connectus/common/enums/message_enums.dart';
import 'package:connectus/common/providers/message_reply_provider.dart';
import 'package:connectus/common/widgets/loader.dart';
import 'package:connectus/features/chat/controller/chat_controller.dart';
import 'package:connectus/models/message.dart';
import 'package:connectus/features/chat/widgets/my_message_card.dart';
import 'package:connectus/features/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({super.key, required this.recieverUserId});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  onMessageSwipe(String message, bool isMe, MessageEnums messageEnums) {
    ref
        .read(messageReplyProvider.notifier)
        .update((state) => MessageReply(message, isMe, messageEnums));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref
          .read(chatControllerProvider)
          .chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            if (!messageData.isSeen &&
                messageData.recieverid ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref
                  .read(chatControllerProvider)
                  .setChatMessageSeen(
                    context,
                    widget.recieverUserId,
                    messageData.messageId,
                  );
            }
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe:
                    () => onMessageSwipe(
                      messageData.text,
                      true,
                      messageData.type,
                    ),
                  isSeen: messageData.isSeen
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe:
                  () =>
                      onMessageSwipe(messageData.text, false, messageData.type),
              repliedText: messageData.repliedMessage,
            );
          },
        );
      },
    );
  }
}
