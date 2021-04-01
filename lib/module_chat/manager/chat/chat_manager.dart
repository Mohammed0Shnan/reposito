import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/module_chat/model/chat/chat_model.dart';
import 'package:flutter_boilerplate/module_chat/repository/chat/chat_repository.dart';
import 'package:inject/inject.dart';


@provide
class ChatManager {
  final ChatRepository _chatRepository;

  ChatManager(this._chatRepository);

  Stream<QuerySnapshot> getMessages(String chatRoomID) {
    return _chatRepository.requestMessages(chatRoomID);
  }

  void sendMessage(String chatRoomID, ChatModel chatMessage) {
    _chatRepository.sendMessage(chatRoomID, chatMessage);
  }
}
