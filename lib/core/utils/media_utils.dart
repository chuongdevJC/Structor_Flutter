import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaUtils{
  static final MediaUtils instance = MediaUtils._instance();

  factory MediaUtils(){
    return instance;
  }
  MediaUtils._instance();

  Future<File> getImageFromLibrary() {
    return ImagePicker.pickImage(source: ImageSource.gallery);
  }

}
