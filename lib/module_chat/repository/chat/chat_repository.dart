import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/module_chat/model/chat/chat_model.dart';
import 'package:inject/inject.dart';

@provide
class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> requestMessages(String chatRoomID) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('sentDate', descending: false)
        .snapshots(includeMetadataChanges: false);
  }

  void sendMessage(String chatRoomID, ChatModel chatMessage) {
    _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(chatMessage.toJson());
  }
}
