import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/friend_repository.dart';
import '../bloc.dart';

class NotificationBloc extends Bloc<NotifcationEvent, NotificationState> {
  NotificationBloc(NotificationState initialState) : super(initialState);
  final _friendRepository = getIt<FriendRepository>();

  @override
  Stream<NotificationState> mapEventToState(NotifcationEvent event) async* {
    if (event is InitializeNotificationEvent) {
      yield* _mapNotificationToState(event.currentUserID);
    }
    if (event is AcceptMakingFriend) {
      yield* _mapUpdateMakingFriendToState(
        event.currentID,
        event.recipientID,
        event.pending,
        event.accept,
      );
    }
    if (event is DeclineMakingFriend) {
      yield* _mapUpdateMakingFriendToState(
        event.currentID,
        event.recipientID,
        event.pending,
        event.accept,
      );
    }
  }

  Stream<NotificationState> _mapUpdateMakingFriendToState(
    String currentID,
    String recipientID,
    bool pending,
    bool accept,
  ) async* {
    try {
      await _friendRepository.updateMakingFriends(
        currentID: currentID,
        recipientID: recipientID,
        pending: pending,
        accept: accept,
      );
      final _currentFriendList =
          await _friendRepository.getFriendListWithoutMe(currentID);
      yield SuccessNotification(_currentFriendList);
    } catch (_) {
      yield FailureNotification();
    }
  }

  Stream<NotificationState> _mapNotificationToState(
    String currentUserID,
  ) async* {
    yield LoadingNotification();
    try {
      final _currentFriendList =
          await _friendRepository.getFriendListWithoutMe(currentUserID);
      yield SuccessNotification(_currentFriendList);
    } catch (_) {
      yield FailureNotification();
    }
  }
}
