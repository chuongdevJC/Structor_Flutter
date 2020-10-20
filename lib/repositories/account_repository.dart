import 'package:injectable/injectable.dart';
import '../data/entities/contact.dart';
import '../data/entities/conversation.dart';
import '../data/entities/message.dart';
import '../data/source/remote/account_remote_datasource.dart';

abstract class AccountRepository {

  Future<void> createUser(String _uid, String _name, String _email, String _imageURL);

  Future<void> updateUserLastSeenTime(String _userID);

  Future<void> sendMessage(String _conversationID, Message _message);

  Future<void> createOrGetConversation(String _currentID, String _recepientID, Future<void> _onSuccess(String _conversationID));

  Stream<Contact> getUserData(String _userID);

  Stream<List<ConversationSnippet>> getUserConversations(String _userID);

  Stream<List<Contact>> searchUsersByName(String _searchName);

  Stream<Conversation> getConversation(String _conversationID);
}

@Singleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {

  static AccountRepositoryImpl instance = AccountRepositoryImpl();

  final AccountRemoteDataSourceImpl _accountRemoteDataSourceImpl = AccountRemoteDataSourceImpl();

  @override
  Future<void> createOrGetConversation(String _currentID, String _recepientID,
      Future<void> Function(String _conversationID) _onSuccess) {
    return _accountRemoteDataSourceImpl.createConversation(
        _currentID, _recepientID, (_conversationID) => null);
  }

  @override
  Future<void> createUser(String _uid, String _name, String _email, String _imageURL) {
    return _accountRemoteDataSourceImpl.createUser(_uid, _name, _email, _imageURL);
  }

  @override
  Stream<Conversation> getConversation(String _conversationID) {
    return _accountRemoteDataSourceImpl.getConversation(_conversationID);
  }

  @override
  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    return _accountRemoteDataSourceImpl.getUserConversations(_userID);
  }

  @override
  Stream<Contact> getUserData(String _userID) {
    return _accountRemoteDataSourceImpl.getUserData(_userID);
  }

  @override
  Future<void> sendMessage(String _conversationID, Message _message) {
    return _accountRemoteDataSourceImpl.sendMessage(_conversationID, _message);
  }

  @override
  Future<void> updateUserLastSeenTime(String _userID) {
    return _accountRemoteDataSourceImpl.updateUserLastSeenTime(_userID);
  }

  @override
  Stream<List<Contact>> searchUsersByName(String _searchName) {
    return _accountRemoteDataSourceImpl.searchUsersByName(_searchName);
  }
}
