import 'package:flutter/material.dart';
import '../../../core/resource/app_colors.dart';
import '../../../core/resource/icon_style.dart';
import '../../../core/resource/text_style.dart';

Widget appBar() {

  return AppBar(
    actions: [
      Container(
        margin: EdgeInsets.only(right: 20.0),
        child: AppIcons.assignment_blue,
      ),
    ],
    title: Text(
      'Chats',
      textAlign: TextAlign.start,
      style: AppStyles.black_none,
    ),
    elevation: 10,
    backgroundColor: AppColors.whiteColor,
  );

}
