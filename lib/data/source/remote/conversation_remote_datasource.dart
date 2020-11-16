import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/conversation_snippet.dart';
import 'package:structure_flutter/data/entities/message.dart';

abstract class ConversationRemoteDataSource {
  Future<void> updateUserLastSeenTime(String userID);

  Future<void> createConversation(
    String currentID,
    String recipientID,
    String currentUserName,
    String currentUserImage,
    String recipientName,
    String recipientImage,
    MessageType type,
    int unseenCount,
  );

  Future<void> createLastConversation({
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    MessageType type,
    int unseenCount,
  });

  Future<void> sendMessage(String conversationID, Message message);

  Future<List<ConversationSnippet>> getLastConversations(String userID);

  Future<List<ConversationSnippet>> getLastConversationByName(
    String userName,
    String recipientID,
  );

  Stream<Conversation> getConversations(String userID);
}

@Singleton(as: ConversationRemoteDataSource)
class ConversationRemoteDataSourceImpl extends ConversationRemoteDataSource {
  final _userCollection = FirebaseFirestore.instance.collection("Users");
  final _conversationCollection =
      FirebaseFirestore.instance.collection("Conversations");

  @override
  Future<void> createConversation(
    String currentID,
    String recipientID,
    String currentUserName,
    String currentUserImage,
    String recipientName,
    String recipientImage,
    MessageType type,
    int unseenCount,
  ) async {
    try {
      final _conversation = _conversationCollection.doc();

      await _conversation.set({
        "members": [currentID, recipientID],
        "ownerID": currentID,
        'messages': [],
      });

      createLastConversation(
        currentID: currentID,
        recipientID: recipientID,
        conversationID: _conversation.id,
        image: recipientImage,
        lastMessage: "",
        name: recipientName,
        type: type,
        unseenCount: unseenCount,
      );

      createLastConversation(
        currentID: recipientID,
        recipientID: currentID,
        conversationID: _conversation.id,
        image: currentUserImage,
        lastMessage: "",
        name: currentUserName,
        type: type,
        unseenCount: unseenCount,
      );
    } catch (_) {}
  }

  @override
  Future<void> createLastConversation({
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    MessageType type,
    int unseenCount,
  }) async {
    return await _userCollection
        .doc(currentID)
        .collection("Conversations")
        .doc(recipientID)
        .set({
      "conversationID": conversationID,
      "image": image,
      "lastMessage": lastMessage,
      "name": name,
      "timestamp": DateTime.now().toUtc(),
      "unseenCount": unseenCount,
    });
  }

  @override
  Future<void> updateUserLastSeenTime(String userID) {
    var _ref = _userCollection.doc(userID);
    return _ref.update({"lastSeen": Timestamp.now()});
  }

  @override
  Future<void> sendMessage(String conversationID, Message message) {
    var _ref = _conversationCollection.doc(conversationID);
    var _messageType = "";
    switch (message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.update({
      "messages": FieldValue.arrayUnion(
        [
          {
            "message": message.content,
            "senderID": message.senderID,
            "timestamp": message.timestamp,
            "type": _messageType,
          },
        ],
      ),
    });
  }

  @override
  Future<List<ConversationSnippet>> getLastConversations(
      String recipientID) async {
    final _lastConversation = await _userCollection
        .doc(recipientID)
        .collection("Conversations")
        .get();
    return _lastConversation.docs
        .map((doc) => ConversationSnippet.fromFireStore(doc))
        .toList();
  }

  @override
  Stream<Conversation> getConversations(String conversationID) async* {
    try {
      Stream<DocumentSnapshot> _docsSnapshot =
          _conversationCollection.doc(conversationID).snapshots();
      await for (DocumentSnapshot event in _docsSnapshot) {
        yield Conversation.fromFireStore(event);
      }
    } catch (_) {
      yield null;
    }
  }

  @override
  Future<List<ConversationSnippet>> getLastConversationByName(
    String searchName,
    String recipientID,
  ) async {
    final _lastConversation = _userCollection
        .doc(recipientID)
        .collection("Conversations")
        .where("name", isLessThanOrEqualTo: searchName);
    final _snapshot = await _lastConversation.get();
    return _snapshot.docs
        .map((doc) => ConversationSnippet.fromFireStore(doc))
        .toList();
  }
}
