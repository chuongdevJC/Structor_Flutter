import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/source/remote/storage_remote_datasource.dart';

abstract class StorageRepository {
  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _image);
  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file);
}

@Singleton(as: StorageRepository)
class StorageRepositoryImpl implements StorageRepository {
  static StorageRepositoryImpl instance = StorageRepositoryImpl();

  final StorageRemoteDataSourceImpl _storageRemoteDataSource =
      StorageRemoteDataSourceImpl();

  @override
  Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, _file) {
    return _storageRemoteDataSource.uploadMediaMessage(_uid, _file);
  }

  @override
  Future<StorageTaskSnapshot> uploadUserImage(String _uid, _image) {
    return _storageRemoteDataSource.uploadUserImage(_uid, _image);
  }
}
