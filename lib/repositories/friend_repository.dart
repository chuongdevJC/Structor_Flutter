import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/account.dart';
import 'package:structure_flutter/data/entities/friend_request.dart';
import 'package:structure_flutter/data/source/remote/friend_remote_datasource.dart';
import 'package:structure_flutter/di/injection.dart';

abstract class FriendRepository {
  Future<void> makingFriends({
    String currentID,
    String recipientID,
    String currentUserName,
    String recipientName,
    bool pending,
    bool accept,
  });

  Future<List<Account>> getAllUserAccounts();

  Future<List<Account>> getAllUserAccountsWithoutMe(String currentUserID);

  Future<List<FriendRequest>> getFriendListWithoutMe(String currentUserID);

  Future<void> updateMakingFriends({
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  });
}

@Singleton(as: FriendRepository)
class FriendRepositoryImpl extends FriendRepository {
  final _friendRemoteDataSource = getIt<FriendRemoteDataSource>();

  @override
  Future<void> makingFriends({
    String currentID,
    String recipientID,
    String currentUserName,
    String recipientName,
    bool pending,
    bool accept,
  }) {
    return _friendRemoteDataSource.makingFriends(
      currentID,
      recipientID,
      currentUserName,
      recipientName,
      pending,
      accept,
    );
  }

  @override
  Future<List<Account>> getAllUserAccounts() async {
    return _friendRemoteDataSource.getAllUserAccounts();
  }

  @override
  Future<List<FriendRequest>> getFriendListWithoutMe(String currentUserID) {
    return _friendRemoteDataSource.getFriendListWithoutMe(currentUserID);
  }

  @override
  Future<void> updateMakingFriends({
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  }) {
    return _friendRemoteDataSource.updateMakingFriends(
      currentID: currentID,
      recipientID: recipientID,
      pending: pending,
      accept: accept,
    );
  }

  @override
  Future<List<Account>> getAllUserAccountsWithoutMe(String currentUserID) {
    return _friendRemoteDataSource.getAllUserAccountsWithoutMe(currentUserID);

  }
}
