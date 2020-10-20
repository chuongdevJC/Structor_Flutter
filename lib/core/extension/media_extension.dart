import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaExtension {
  static MediaExtension instance = MediaExtension();

  Future<File> getImageFromLibrary() {
    return ImagePicker.pickImage(source: ImageSource.gallery);
  }
}