import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/account.dart';
import 'package:structure_flutter/data/entities/conversation.dart';

abstract class AccountRemoteDataSource {
  Future<void> createUser(
    String uid,
    String name,
    String email,
    String imageURL,
  );

  Future<List<Account>> getUsers(String searchName);

  List<QueryDocumentSnapshot> getAllUsers(
    AsyncSnapshot<QuerySnapshot> snapshot,
  );

  Future<void> sendFriendRequest(
    String currentID,
    recipientID,
    String name,
    bool pending,
  );

  Future<void> createLastConversation(
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    int unseenCount,
  );

  Stream<Conversation> getConversation(String _conversationID);

  Stream<List<ConversationSnippet>> getUserConversations(String _userID);

  Future<void> createConversation(
    String _currentID,
    String _recipientID,
    Future<void> Function(String _conversationID) _onSuccess,
  );
}

@Singleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final _userCollection = FirebaseFirestore.instance.collection("Users");

  final _conversations = "Conversations";

  final _conversationCollection =
      FirebaseFirestore.instance.collection("Conversations");

  @override
  Future<void> createUser(
    String uid,
    String name,
    String email,
    String imageURL,
  ) async {
    try {
      return await _userCollection.doc(uid).set({
        "id": uid,
        "name": name,
        "email": email,
        "image": imageURL,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> createConversation(
    String currentID,
    String recipientID,
    Future<void> Function(String conversationID) onSuccess,
  ) async {
    var _conversationRef =
        _userCollection.doc(currentID).collection("Conversations");
    try {
      var _lastConversation = await _conversationRef.doc(recipientID).get();
      if (_lastConversation.data != null) {
        return onSuccess(_lastConversation.data()["conversationID"]);
      } else {
        var _conversationRef = _conversationCollection.doc();
        await _conversationRef.set(
          {
            "members": [currentID, recipientID],
            "ownerID": currentID,
            'messages': [],
          },
        );
        return onSuccess(_conversationRef.id);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Account>> getUsers(String searchName) async {
    var _ref = _userCollection
        .where("name", isGreaterThanOrEqualTo: searchName)
        .where("name", isLessThan: searchName + 'z');
    final _snapshot = await _ref.get();
    return _snapshot.docs.map((doc) => Account.fromFireStore(doc)).toList();
  }

  @override
  List<QueryDocumentSnapshot> getAllUsers(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data != null) {
      return snapshot.data.docs;
    }
  }

  @override
  Future<void> sendFriendRequest(
    String currentID,
    recipientID,
    String name,
    bool pending,
  ) async {
    try {
      return await _userCollection
          .doc(currentID)
          .collection("Friends")
          .doc(recipientID)
          .set({"name": name, "pending": pending});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Stream<Conversation> getConversation(String _conversationID) {
    var _ref = _conversationCollection.doc(_conversationID);
    return _ref
        .snapshots()
        .map((_message) => Conversation.fromFireStore(_message));
  }

  @override
  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _userCollection.doc(_userID).collection("Conversations");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFireStore(_doc);
      }).toList();
    });
  }

  @override
  Future<void> createLastConversation(
    String currentID,
    String recipientID,
    String conversationID,
    String image,
    String lastMessage,
    String name,
    int unseenCount,
  ) async {
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

}
