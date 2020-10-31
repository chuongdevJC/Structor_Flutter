import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/bloc/events/register_event.dart';
import 'package:structure_flutter/bloc/states/register_state.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/user_repository.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _userRepository = getIt<UserRepository>();

  RegisterBloc(RegisterState initialState) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterWithCredentials) {
      yield* _mapRegisterAccountToState(
        email: event.email.trim(),
        password: event.password.trim(),
      );
    }
  }

  Stream<RegisterState> _mapRegisterAccountToState({
    @required String email,
    @required String password,
  }) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
