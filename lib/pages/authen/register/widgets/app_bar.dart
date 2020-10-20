import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/pages/authen/login/login_page.dart';

Widget appBar(BuildContext context) {
  return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        },
        icon: arrowback_none,
        color: blackColor,
      ));
}
