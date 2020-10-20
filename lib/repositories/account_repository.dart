import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/contact.dart';
import 'package:structure_flutter/data/entities/conversation.dart';
import 'package:structure_flutter/data/entities/message.dart';
import 'package:structure_flutter/data/entities/user.dart';
import 'package:structure_flutter/data/source/remote/account_remote_datasource.dart';
import 'package:structure_flutter/data/source/remote/storage_remote_datasource.dart';
import 'package:structure_flutter/data/source/remote/user_remote_datasource.dart';

import '../data/entities/user.dart';

abstract class AccountRepository {
  Future<List<UserGitEntity>> getUser(int page);

  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL);

  Future<void> updateUserLastSeenTime(String _userID);

  Future<void> sendMessage(String _conversationID, Message _message);

  Future<void> createOrGetConversation(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID));

  Stream<Contact> getUserData(String _userID);

  Stream<List<ConversationSnippet>> getUserConversations(String _userID);

  Stream<List<Contact>> getUsersInDB(String _searchName);

  Stream<Conversation> getConversation(String _conversationID);
}

@Singleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  //VERSION-1.0
  // final UserRemoteDataSource _userRemoteDataSource;
  // UserRepositoryImpl(this._userRemoteDataSource);
  // @override
  // Future<List<UserGitEntity>> getUser(int page) async {
  //   return _userRemoteDataSource.getUser(page);
  // }

  @override
  Future<List<UserGitEntity>> getUser(int page) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  static AccountRepositoryImpl instance = AccountRepositoryImpl();

  final AccountRemoteDataSourceImpl _accountRemoteDataSourceImpl =
  AccountRemoteDataSourceImpl();

  @override
  Future<void> createOrGetConversation(String _currentID, String _recepientID,
      Future<void> Function(String _conversationID) _onSuccess) {
    return _accountRemoteDataSourceImpl.createOrGetConversation(
        _currentID, _recepientID, (_conversationID) => null);
  }

  @override
  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) {
    return _accountRemoteDataSourceImpl.createUserInDB(_uid, _name, _email, _imageURL);
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
  Stream<List<Contact>> getUsersInDB(String _searchName) {
    return _accountRemoteDataSourceImpl.getUsersInDB(_searchName);
  }

  @override
  Future<void> sendMessage(String _conversationID, Message _message) {
    return _accountRemoteDataSourceImpl.sendMessage(_conversationID, _message);
  }

  @override
  Future<void> updateUserLastSeenTime(String _userID) {
    return _accountRemoteDataSourceImpl.updateUserLastSeenTime(_userID);
  }
}
