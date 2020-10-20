import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/entities/user.dart';
import 'package:path/path.dart';
abstract class StorageRemoteDataSource {
  Future<List<UserGitEntity>> getUser(int page);

  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _image);

  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file);
}

@Singleton(as: StorageRemoteDataSource)
class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  // final DioClient _dioClient;
  //
  // StorageRemoteDataSourceImpl(this._dioClient);
  //
  // @override
  // Future<List<UserGitEntity>> getUser(int page) async {
  //   final response = await _dioClient.get('/search/users',
  //       queryParameters: {'q': 'abc', 'page': page, 'per_page': 10});
  //   return UserGitResponse.fromJson(response).userGits;
  // }

  @override
  Future<List<UserGitEntity>> getUser(int page) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  static StorageRemoteDataSourceImpl instance = StorageRemoteDataSourceImpl();

  FirebaseStorage _storage;
  StorageReference _baseRef;

  String _profileImages = "profile_images";
  String _messages = "messages";
  String _images = "images";

  StorageRemoteDataSourceImpl() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }


  @override
  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file) {
    var _timestamp = DateTime.now();
    var _fileName = basename(_file.path);
    _fileName += "_${_timestamp.toString()}";
    try {
      return _baseRef
          .child(_messages)
          .child(_uid)
          .child(_images)
          .child(_fileName)
          .putFile(_file)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _image) {
    try {
      return _baseRef
          .child(_profileImages)
          .child(_uid)
          .putFile(_image)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }
}
