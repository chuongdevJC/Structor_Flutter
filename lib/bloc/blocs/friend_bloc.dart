import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/events/friend_event.dart';
import 'package:structure_flutter/bloc/states/friend_state.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/friend_repository.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  FriendBloc(FriendState initialState) : super(initialState);
  final _friendRepository = getIt<FriendRepository>();

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if (event is InitializeFriendList) {
      yield* _mapLoadDataToState(
        event.currentUserID,
      );
    }
    if (event is MakingFriendRequest) {
      yield* _mapSendFriendRequestToState(
        event.currentUserID,
        event.currentUserName,
        event.recipientID,
        event.recipientName,
      );
    }
  }

  Stream<FriendState> _mapLoadDataToState(
    String currentUserID,
  ) async* {
    yield LoadingData();
    try {
      final _accounts =
          await _friendRepository.getAllUserAccountsWithoutMe(currentUserID);
      yield Success(_accounts);
    } catch (_) {
      yield Failure();
    }
  }

  Stream<FriendState> _mapSendFriendRequestToState(
    String currentUserID,
    String currentUserName,
    String recipientID,
    String recipientName,
  ) async* {
    try {
      await _friendRepository.makingFriends(
        currentID: currentUserID,
        currentUserName: currentUserName,
        recipientID: recipientID,
        recipientName: recipientName,
        pending: true,
        accept: false,
      );
      final _accounts = await _friendRepository.getAllUserAccounts();
      yield Success(_accounts);
    } catch (_) {
      yield Failure();
    }
  }
}
