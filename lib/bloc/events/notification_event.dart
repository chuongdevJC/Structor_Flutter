import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class NotifcationEvent extends Equatable {
  NotifcationEvent([List props = const []]) : super();
}

class InitializeNotificationEvent extends NotifcationEvent {
  final String message = "InitializeLoadData";
  String currentUserID;

  InitializeNotificationEvent({this.currentUserID});

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message, currentUserID];
}

class AcceptMakingFriend extends NotifcationEvent {
  String currentID;
  String recipientID;
  bool pending;
  bool accept;

  AcceptMakingFriend(
    this.currentID,
    this.recipientID,
    this.pending,
    this.accept,
  );

  @override
  List<Object> get props => [
        currentID,
        recipientID,
        pending,
        accept,
      ];
}

class DeclineMakingFriend extends NotifcationEvent {
  String currentID;
  String recipientID;
  bool pending;
  bool accept;

  DeclineMakingFriend(
    this.currentID,
    this.recipientID,
    this.pending,
    this.accept,
  );

  @override
  List<Object> get props => [
        currentID,
        recipientID,
        pending,
        accept,
      ];
}
