import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../data/entities/user.dart';
import '../../../data/source/remote/api/response/user_git_response.dart';
import '../../../data/source/remote/service/dio_client.dart';

abstract class UserRemoteDataSource {
  Future<List<UserGitEntity>> getUser(int page);
}

@Singleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;

  UserRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<UserGitEntity>> getUser(int page) async {
    final response = await _dioClient.get('/search/users',
        queryParameters: {'q': 'abc', 'page': page, 'per_page': 10});
    return UserGitResponse.fromJson(response).userGits;
  }
}
