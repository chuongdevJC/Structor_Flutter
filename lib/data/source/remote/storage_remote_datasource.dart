import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
abstract class StorageRemoteDataSource {

  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _image);

  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file);
}

@Singleton(as: StorageRemoteDataSource)
class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  FirebaseStorage _storage;
  StorageReference _baseRef;

  String _profileImages = "profile_images";
  String _messages = "messages";
  String _images = "images";

  static StorageRemoteDataSourceImpl instance = StorageRemoteDataSourceImpl();

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
