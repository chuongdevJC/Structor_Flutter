import 'package:flutter/material.dart';
import '../../../../core/resource/app_colors.dart';
import '../../../../core/resource/icon_style.dart';
import '../../../../pages/authen/login/login_page.dart';

Widget appBar(BuildContext context) {
  return AppBar(
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        icon: AppIcons.arrowback_none,
        color: AppColors.blackColor,
      ));
}
