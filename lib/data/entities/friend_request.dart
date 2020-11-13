import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String name;
  final bool pending;
  final bool accept;

  FriendRequest({
    this.id,
    this.name,
    this.pending,
    this.accept,
  });

  factory FriendRequest.fromFireStore(DocumentSnapshot snapshot) {
    var _data = snapshot.data;
    return FriendRequest(
      id: snapshot.id,
      name: _data()["name"],
      pending: _data()["pending"],
      accept: _data()["accept"],
    );
  }
}
