import 'package:injectable/injectable.dart';
import 'package:structure_flutter/core/common/helpers/state_helper.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/remote/api/error/failures.dart';
import 'package:structure_flutter/data/source/remote/api/request/get_user_request.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/data/source/remote/user_remote_datasource.dart';

abstract class UserRepository {
  Future<State<List<User>, Failures>> getUser(GetUsersRequest request);
  Stream<Result<State<List<User>, Failures>>> getListUserNetworkBound(GetUsersRequest request);
}

@Singleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl(this._userRemoteDataSource);

  @override
  Future<State<List<User>, Failures>> getUser(GetUsersRequest request) async {
    return _userRemoteDataSource.getUser(request);
  }

  @override
  Stream<Result<State<List<User>, Failures>>> getListUserNetworkBound(GetUsersRequest request) {
    return _userRemoteDataSource.getListUserNetworkBound(request);
  }
}
