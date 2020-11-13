import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageRemoteDataSource {
  Future<StorageTaskSnapshot> uploadUserImage(String uid, File image);

  Future<String> getDownloadURL();
}

class StorageRemoteDataSourceImpl extends StorageRemoteDataSource {
  StorageReference _baseRef;

  StorageRemoteDataSourceImpl(this._baseRef);

  String _profileImages = "profile_images";

  @override
  Future<StorageTaskSnapshot> uploadUserImage(String uid, File image) {
    try {
      return _baseRef
          .child(_profileImages)
          .child(uid)
          .putFile(image)
          .onComplete;
    } catch (_) {}
  }

  @override
  Future<String> getDownloadURL() {
    try {
      final _firebaseStorage = _baseRef.child(_profileImages);
      return _firebaseStorage.getDownloadURL();
    } catch (_) {
      return null;
    }
  }
}
