import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../data/entities/contact.dart';
import '../../../data/entities/conversation.dart';
import '../../../data/entities/message.dart';

abstract class AccountRemoteDataSource {
  Future<void> createUser(
      String _uid, String _name, String _email, String _imageURL);

  Future<void> updateUserLastSeenTime(String _userID);

  Future<void> sendMessage(String _conversationID, Message _message);

  Future<void> createConversation(String _currentID, String _recipientID,
      Future<void> _onSuccess(String _conversationID));

  Stream<Contact> getUserData(String _userID);

  Stream<List<ConversationSnippet>> getUserConversations(String _userID);

  Stream<List<Contact>> searchUsersByName(String _searchName);

  Stream<Conversation> getConversation(String _conversationID);
}

@Singleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  // Singleton
  static final AccountRemoteDataSourceImpl instance = AccountRemoteDataSourceImpl._instance();

  factory AccountRemoteDataSourceImpl() {
    return instance;
  }

  AccountRemoteDataSourceImpl._instance() {
    _db = FirebaseFirestore.instance;
  }

  FirebaseFirestore _db;
  String _userCollection = "Users";
  String _conversationsCollection = "Conversations";

  @override
  Future<void> createConversation(String _currentID, String _recipientID,
      Future<void> Function(String _conversationID) _onSuccess) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .doc(_currentID)
        .collection(_conversationsCollection);
    try {
      var conversation = await _userConversationRef.doc(_recipientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data()["conversationID"]);
      } else {
        var _conversationRef = _ref.doc();
        await _conversationRef.setData(
          {
            "members": [_currentID, _recipientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.id);
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
        return Conversation.fromFireStore(_doc);
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
  Stream<List<Contact>> searchUsersByName(String _searchName) {
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
  Future<void> createUser(
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
