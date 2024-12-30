import 'dart:io';

import 'package:connectus/colors.dart';
import 'package:connectus/common/enums/message_enums.dart';
import 'package:connectus/common/utils/utils.dart';
import 'package:connectus/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({super.key, required this.recieverUSerId});
  final String recieverUSerId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  bool isShowSendButton = false;

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUSerId,
          );

      setState(() {
        _messageController.text = '';
      });
    }
  }

  void sendFileMessage(File file,MessageEnums messageEnum){
    ref.read(chatControllerProvider).sendFileMessage(context, file, widget.recieverUSerId, messageEnum);
  }
  void selectImage() async{
    File? image= await pickImageFromGallery(context);
    if(image!=null){
      sendFileMessage(image, MessageEnums.image);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            controller: _messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 48,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.photo_camera, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.attach_file, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 2, left: 2),
          child: CircleAvatar(
            backgroundColor: tabColor,
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
