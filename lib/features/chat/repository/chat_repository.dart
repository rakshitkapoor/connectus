import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectus/common/enums/message_enums.dart';
import 'package:connectus/common/providers/message_reply_provider.dart';
import 'package:connectus/common/repository/common_firebase_storage_repository.dart';
import 'package:connectus/common/utils/utils.dart';
import 'package:connectus/models/chat_contact.dart';
import 'package:connectus/models/message.dart';
import 'package:connectus/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
          List<ChatContact> contacts = [];
          for (var document in event.docs) {
            var chatContact = ChatContact.fromMap(document.data());
            var userData =
                await firestore
                    .collection('users')
                    .doc(chatContact.contactId)
                    .get();
            var user = UserModel.fromMap(userData.data()!);

            contacts.add(
              ChatContact(
                name: user.name,
                profilePic: user.profilePic,
                contactId: chatContact.contactId,
                timeSent: chatContact.timeSent,
                lastMessage: chatContact.lastMessage,
              ),
            );
          }
          return contacts;
        });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
          List<Message> messages = [];
          for (var document in event.docs) {
            messages.add(Message.fromMap(document.data()));
          }
          return messages;
        });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    // users -> reciever user id -> chats -> current user id => set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());
    // users -> current user id -> chats -> reciever user id -> => set data
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required recieverUsername,
    required MessageEnums messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String recieverUserName,
    required MessageEnums repliedMessageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo:
          messageReply == null
              ? ''
              : messageReply.isMe
              ? senderUsername
              : recieverUserName,
          repliedMessageType: repliedMessageType
    );
    // users -> sender id -> reciever user id -> message -> message id -> store message;
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply, 
  }) async {
    // users -> sender id -> reciever user id -> message -> message id -> store message;
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      // users -> reciever user id -> chats -> current user id => set data
      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnums.text,
        messageId: messageId,
        recieverUsername: recieverUserData.name,
        username: senderUser.name,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUser.name,
        repliedMessageType: messageReply == null ? MessageEnums.text : messageReply.messageEnums
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required Ref ref,
    required MessageEnums messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(CommonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;
      switch (messageEnum) {
        case MessageEnums.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnums.video:
          contactMsg = '📷 Video';
          break;
        case MessageEnums.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnums.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDataToContactsSubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        recieverUsername: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUserData.name,
        repliedMessageType: messageReply == null ? MessageEnums.text : messageReply.messageEnums
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void chatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  )async{
    try {
      await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .update({
          'isSeen':true
        });

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .update({
          'isSeen': true
        });
    } catch (e) {
      
    }

  }
}
