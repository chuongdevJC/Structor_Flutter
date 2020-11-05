import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/data/entities/account.dart';
import 'package:structure_flutter/data/source/remote/account_remote_datasource.dart';
import 'package:structure_flutter/di/injection.dart';

abstract class AccountRepository {
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

  Future<void> createConversation(
    String _currentID,
    String _recipientID,
    Future<void> _onSuccess(String _conversationID),
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
}

class AccountRepositoryImpl extends AccountRepository {
  final _accountRemoteDataSource = getIt<AccountRemoteDataSource>();

  @override
  Future<void> createConversation(
    String _currentID,
    String _recipientID,
    Future<void> _onSuccess(String _conversationID),
  ) {
    return _accountRemoteDataSource.createConversation(
      _currentID,
      _recipientID,
      (_conversationID) => null,
    );
  }

  @override
  Future<void> createUser(
    String uid,
    String name,
    String email,
    String imageURL,
  ) {
    return _accountRemoteDataSource.createUser(uid, name, email, imageURL);
  }

  Future<List<Account>> getUsers(String searchName) {
    return _accountRemoteDataSource.getUsers(searchName);
  }

  @override
  List<QueryDocumentSnapshot> getAllUsers(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return _accountRemoteDataSource.getAllUsers(snapshot);
  }

  @override
  Future<void> sendFriendRequest(
    String currentID,
    recipientID,
    String name,
    bool pending,
  ) {
    return _accountRemoteDataSource.sendFriendRequest(
        currentID, recipientID, name, pending);
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
  ) {
    return _accountRemoteDataSource.createLastConversation(
        currentID,
        recipientID,
        conversationID,
        image,
        lastMessage,
        name,
        unseenCount);
  }
}
