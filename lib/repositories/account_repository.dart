import 'package:injectable/injectable.dart';
import '../data/entities/contact.dart';
import '../data/entities/conversation.dart';
import '../data/entities/message.dart';
import '../data/source/remote/account_remote_datasource.dart';

abstract class AccountRepository {

  Future<void> createUser(String _uid, String _name, String _email, String _imageURL);

  Future<void> updateUserLastSeenTime(String _userID);

  Future<void> sendMessage(String _conversationID, Message _message);

  Future<void> createConversation(String _currentID, String _recipientID, Future<void> _onSuccess(String _conversationID));

  Stream<Contact> getUserData(String _userID);

  Stream<List<ConversationSnippet>> getUserConversations(String _userID);

  Stream<List<Contact>> searchUsersByName(String _searchName);

  Stream<Conversation> getConversation(String _conversationID);
}

@Singleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {

  //Singleton
  static final AccountRepositoryImpl instance = AccountRepositoryImpl._instance();
  factory AccountRepositoryImpl(){
    return instance;
  }
  AccountRepositoryImpl._instance();
  
  @override
  Future<void> createConversation(String _currentID, String _recipientID,
      Future<void> Function(String _conversationID) _onSuccess) {
    return AccountRemoteDataSourceImpl.instance.createConversation(
        _currentID, _recipientID, (_conversationID) => null);
  }

  @override
  Future<void> createUser(String _uid, String _name, String _email, String _imageURL) {
    return AccountRemoteDataSourceImpl.instance.createUser(_uid, _name, _email, _imageURL);
  }

  @override
  Stream<Conversation> getConversation(String _conversationID) {
    return AccountRemoteDataSourceImpl.instance.getConversation(_conversationID);
  }

  @override
  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    return AccountRemoteDataSourceImpl.instance.getUserConversations(_userID);
  }

  @override
  Stream<Contact> getUserData(String _userID) {
    return AccountRemoteDataSourceImpl.instance.getUserData(_userID);
  }

  @override
  Future<void> sendMessage(String _conversationID, Message _message) {
    return AccountRemoteDataSourceImpl.instance.sendMessage(_conversationID, _message);
  }

  @override
  Future<void> updateUserLastSeenTime(String _userID) {
    return AccountRemoteDataSourceImpl.instance.updateUserLastSeenTime(_userID);
  }

  @override
  Stream<List<Contact>> searchUsersByName(String _searchName) {
    return AccountRemoteDataSourceImpl.instance.searchUsersByName(_searchName);
  }

}
