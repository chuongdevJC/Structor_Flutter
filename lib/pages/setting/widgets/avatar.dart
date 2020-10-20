import 'package:flutter/material.dart';
import '../../../core/resource/assets_images.dart';
import '../../../core/resource/text_style.dart';

Widget ProfileAvatar() {
  return Column(
    children: [
      CircleAvatar(
        radius: 50,
        backgroundImage:
            NetworkImage(avatar_image),
      ),
      Text(
        'Thuyen Pham',
        style: AppIcons.font_25,
      ),
    ],
  );
}
