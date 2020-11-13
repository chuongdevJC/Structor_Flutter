import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/data/source/remote/storage_remote_datasource.dart';
import 'package:structure_flutter/di/injection.dart';

abstract class StorageRepository {
  Future<String> getDownloadURL();

  Future<StorageTaskSnapshot> uploadUserImage(String uid, File image);
}

@Singleton(as: StorageRepository)
class StorageRepositoryImpl extends StorageRepository {
  final _storageRemoteDataSource = getIt<StorageRemoteDataSource>();

  Future<StorageTaskSnapshot> uploadUserImage(String uid, File image) {
    return _storageRemoteDataSource.uploadUserImage(uid, image);
  }

  @override
  Future<String> getDownloadURL() {
    return _storageRemoteDataSource.getDownloadURL();
  }
}
