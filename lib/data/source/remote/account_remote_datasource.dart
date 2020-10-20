import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/contact.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/message.dart';

abstract class AccountRemoteDataSource {
  Future<void> createUserInDB(String _uid, String _name, String _email, String _imageURL);
  Future<void> updateUserLastSeenTime(String _userID);
  Future<void> sendMessage(String _conversationID, Message _message);
  Future<void> createOrGetConversation(String _currentID, String _recepientID, Future<void> _onSuccess(String _conversationID));
  Stream<Contact> getUserData(String _userID);
  Stream<List<ConversationSnippet>> getUserConversations(String _userID);
  Stream<List<Contact>> getUsersInDB(String _searchName);
  Stream<Conversation> getConversation(String _conversationID);
}

@Singleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  static AccountRemoteDataSourceImpl instance = AccountRemoteDataSourceImpl();

  FirebaseFirestore _db;

  AccountRemoteDataSourceImpl() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";
  String _conversationsCollection = "Conversations";

  @override
  Future<void> createOrGetConversation(String _currentID, String _recepientID,
      Future<void> Function(String _conversationID) _onSuccess) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .doc(_currentID)
        .collection(_conversationsCollection);
    try {
      var conversation = await _userConversationRef.doc(_recepientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data()["conversationID"]);
      } else {
        var _conversationRef = _ref.doc();
        await _conversationRef.setData(
          {
            "members": [_currentID, _recepientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.documentID);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Stream<Conversation> getConversation(String _conversationID) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    return _ref.snapshots().map(
      (_doc) {
        return Conversation.fromFirestore(_doc);
      },
    );
  }

  @override
  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db
        .collection(_userCollection)
        .doc(_userID)
        .collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  @override
  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  @override
  Stream<List<Contact>> getUsersInDB(String _searchName) {
    var _ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where("name", isLessThan: _searchName + 'z');
    return _ref.get().asStream().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    var _messageType = "";
    switch (_message.type) {
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
            "message": _message.content,
            "senderID": _message.senderID,
            "timestamp": _message.timestamp,
            "type": _messageType,
          },
        ],
      ),
    });
  }

  @override
  Future<void> updateUserLastSeenTime(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.update({"lastSeen": Timestamp.now()});
  }

  @override
  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) async {
    try {
      return await _db.collection(_userCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
        "image": _imageURL,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }
}
