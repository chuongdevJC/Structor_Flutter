import 'package:equatable/equatable.dart';

abstract class FriendEvent extends Equatable {
  FriendEvent([List props = const []]) : super();
}

class InitializeFriendList extends FriendEvent {
  final String message = "InitializeLoadData";
  String currentUserID;

  InitializeFriendList(this.currentUserID);

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message, currentUserID];
}

class MakingFriendRequest extends FriendEvent {
  String currentUserID;
  String currentUserName;
  String recipientID;
  String recipientName;

  MakingFriendRequest(
    this.currentUserID,
    this.currentUserName,
    this.recipientID,
    this.recipientName,
  );

  @override
  List<Object> get props =>
      [recipientID, recipientName, currentUserID, currentUserName];
}

class SendRequest extends FriendEvent {
  final String message = "InitializeLoadData";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message];
}
