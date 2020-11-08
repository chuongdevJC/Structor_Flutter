import 'package:injectable/injectable.dart';
import 'package:structure_flutter/core/common/helpers/state_helper.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/local/database/local_database.dart';
import 'package:structure_flutter/data/source/remote/api/response/user_git_response.dart';
import 'package:structure_flutter/data/source/remote/network_bound_resource.dart';
import 'package:structure_flutter/data/source/remote/result.dart';
import 'package:structure_flutter/data/source/remote/service/dio_client.dart';

import 'api/error/failures.dart';
import 'api/request/get_user_request.dart';

abstract class UserRemoteDataSource {
  Future<State<List<User>, Failures>> getUser(GetUsersRequest request);

  // Network Bound Region
  Stream<Result<State<List<User>, Failures>>> getListUserNetworkBound(GetUsersRequest request);
}

@Singleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final LocalDatabase _localDatabase;

  UserRemoteDataSourceImpl(this._dioClient, this._localDatabase);

  @override
  Future<State<List<User>, Failures>> getUser(GetUsersRequest request) async {
    try {
      final response =
          await _dioClient.get(request.url, queryParameters: request.toJson());
      var data = UserGitResponse.fromJson(response)
          .userGits
          .map((e) => User.copyWithRemote(e))
          .toList();
      return State.success(data);
    } catch (e) {
      final ServerFailure failure = ServerFailure(e.toString());
      return State.error(failure);
    }
  }

  @override
  Stream<Result<State<List<User>, Failures>>> getListUserNetworkBound(
      GetUsersRequest request) {
    return NetworkBoundResource<State<List<User>, Failures>, State<List<User>, Failures>>().asStream(
      loadFromDb: () => _localDatabase.userDao.getAllUsers(),
      createCall: () => getUser(request),
      saveCallResult: (result) => _localDatabase.userDao.insertUsers(result.data),
    );
  }
}
