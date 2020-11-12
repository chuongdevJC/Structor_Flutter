import 'package:equatable/equatable.dart';
import 'package:structure_flutter/data/entities/friend_request.dart';

abstract class NotificationState extends Equatable {
  NotificationState([List props = const []]) : super();
}

class InitializeNotificationState extends NotificationState {
  final String message = "loading";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message];
}

class LoadingNotification extends NotificationState {
  final String message = "loading";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message];
}

class FailureNotification extends NotificationState {
  final String message = "Failure!";

  @override
  String toString() {
    return message;
  }

  @override
  List<Object> get props => [message];
}

class SuccessNotification extends NotificationState {
  final List<FriendRequest> currentFriendsList;

  SuccessNotification(this.currentFriendsList);

  @override
  List<Object> get props => [currentFriendsList];
}
