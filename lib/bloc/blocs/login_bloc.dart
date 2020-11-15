import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../di/injection.dart';
import '../../repositories/user_repository.dart';
import '../bloc.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _userRepository = getIt<UserRepository>();

  LoginBloc(LoginState initialState) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGoogle) {
      yield* _mapLoginWithGooglePressedToState();
    }
    if (event is LoginWithCredentials) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email.trim(),
        password: event.password.trim(),
      );
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      final _user = await _userRepository.signInWithGoogle();
      yield LoginState.success(_user);
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUser();
        yield LoginState.success(name);
      } else {
        final _user =
            await _userRepository.signInWithCredentials(email, password);
        yield LoginState.success(_user);
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
