import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:structure_flutter/bloc/events/user_event.dart';
import 'package:structure_flutter/bloc/states/user_state.dart';
import 'package:structure_flutter/core/common/helpers/state_helper.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/remote/api/error/failures.dart';
import 'package:structure_flutter/data/source/remote/api/request/get_user_request.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/user_repository.dart';

@singleton
class UserGitBloc extends Bloc<UserGitEvent, UserGitState> {
  final UserRepository _userRepository = getIt<UserRepository>();

  UserGitBloc() : super(UserGitUnInitialized());

  @override
  Stream<Transition<UserGitEvent, UserGitState>> transformEvents(
      Stream<UserGitEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<UserGitState> mapEventToState(UserGitEvent event) async* {
    if (event is Fetch && !_hasReachedMax(state)) {
      if (state is UserGitUnInitialized) {
        await for (Result<State<List<User>, Failures>> result
            in fetchUserGitNetworkBound(1)) {
          yield result.whenWithResult((success) {
            return (success.data as State).fold(
                (users) => UserGitLoaded(users: users, hasReachMax: false),
                (e) => UserGitError());
          }, (inProgress) {
            return (inProgress.data as State).fold(
                (users) => UserGitLoaded(users: users, hasReachMax: false),
                (e) => UserGitError());
          }, (error) {
            return UserGitError();
          });
        }
      } else if (state is UserGitLoaded) {
        final page = ((state as UserGitLoaded).users.length / 10).ceil() + 1;
        final data = await fetchUserGit(page);
        yield data.fold(
            (users) => users.length < 10
                ? (state as UserGitLoaded).copyWith(hasReachedMax: true)
                : UserGitLoaded(
                    users: (state as UserGitLoaded).users + users,
                    hasReachMax: false),
            (e) => UserGitError());
      }
    }
  }

  bool _hasReachedMax(UserGitState state) =>
      state is UserGitLoaded && state.hasReachMax;

  Stream<Result<State<List<User>, Failures>>> fetchUserGitNetworkBound(
      int page) {
    return _userRepository.getListUserNetworkBound(_getUsersRequest(page));
  }

  Future<State<List<User>, Failures>> fetchUserGit(int page) async {
    return _userRepository.getUser(_getUsersRequest(page));
  }

  GetUsersRequest _getUsersRequest(int page) {
    return GetUsersRequest('abc', page: page, limit: 10);
  }
}
