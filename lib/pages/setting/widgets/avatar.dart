import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/assets_images.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

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
        style: font_25,
      ),
    ],
  );
}
