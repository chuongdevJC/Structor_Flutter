import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import '../data/source/remote/storage_remote_datasource.dart';

abstract class StorageRepository {
  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _image);

  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file);
}

@Singleton(as: StorageRepository)
class StorageRepositoryImpl implements StorageRepository {
  static final StorageRepositoryImpl instance = StorageRepositoryImpl();

  factory StorageRepositoryImpl() {
    return instance;
  }

  StorageRepositoryImpl._instance();

  @override
  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, _file) {
    return StorageRemoteDataSourceImpl.instance.uploadMediaMessage(_uid, _file);
  }

  @override
  Future<StorageTaskSnapshot> uploadUserImage(String _uid, _image) {
    return StorageRemoteDataSourceImpl.instance.uploadUserImage(_uid, _image);
  }

}
