import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

Widget appBar() {
  return AppBar(
    actions: [
      Container(
        margin: EdgeInsets.only(right: 20.0),
        child: assignment_blue,
      ),
    ],
    title: Text(
      'Chats',
      textAlign: TextAlign.start,
      style: black_none,
    ),
    elevation: 10,
    backgroundColor: whiteColor,
  );
}
