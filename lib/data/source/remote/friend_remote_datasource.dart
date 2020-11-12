import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/account.dart';
import 'package:structure_flutter/data/entities/friend_request.dart';

abstract class FriendRemoteDataSource {
  Future<void> makingFriends(
    String currentID,
    String recipientID,
    String currentUserName,
    String recipientName,
    bool pending,
    bool accept,
  );

  Future<List<Account>> getAllUserAccounts();

  Future<List<FriendRequest>> getFriendListWithoutMe(String currentUserID);

  Future<void> updateMakingFriends({
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  });
}

@Singleton(as: FriendRemoteDataSource)
class FriendRemoteDataSourceImpl extends FriendRemoteDataSource {
  final _userCollection = FirebaseFirestore.instance.collection("Users");

  @override
  Future<void> makingFriends(
    String currentID,
    String recipientID,
    String currentUserName,
    String recipientName,
    bool pending,
    bool accept,
  ) async {
    try {
      //update status current
      await _userCollection
          .doc(currentID)
          .collection("Friends")
          .doc(recipientID)
          .set({
        "ID": recipientID,
        "name": recipientName,
        "pending": pending,
        "accept": accept,
      });
      //update status recipient
      await _userCollection
          .doc(recipientID)
          .collection("Friends")
          .doc(currentID)
          .set({
        "ID": currentID,
        "name": currentUserName,
        "pending": pending,
        "accept": accept,
      });
    } catch (_) {}
  }

  @override
  Future<List<Account>> getAllUserAccounts() async {
    final _snapshot = await _userCollection.get();
    final _listAccounts =
        _snapshot.docs.map((doc) => Account.fromFireStore(doc)).toList();
    return _listAccounts;
  }

  @override
  Future<List<FriendRequest>> getFriendListWithoutMe(
      String currentUserID) async {
    final _snapshot =
        await _userCollection.doc(currentUserID).collection("Friends").get();
    final _friendListAccounts =
        _snapshot.docs.map((e) => FriendRequest.fromFireStore(e)).toList();
    _friendListAccounts.removeWhere((element) => element.pending == false);
    return _friendListAccounts;
  }

  @override
  Future<void> updateMakingFriends({
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  }) async {
    await _userCollection
        .doc(recipientID)
        .collection("Friends")
        .doc(currentID)
        .update({
      "ID": currentID,
      "pending": pending,
      "accept": accept,
    });

    await _userCollection
        .doc(currentID)
        .collection("Friends")
        .doc(recipientID)
        .update({
      "ID": currentID,
      "pending": pending,
      "accept": !accept,
    });
  }
}
