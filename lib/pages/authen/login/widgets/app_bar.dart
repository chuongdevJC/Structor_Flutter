import 'package:flutter/material.dart';
import '../../../../core/resource/app_colors.dart';

import '../../../../core/resource/icon_style.dart';

Widget appBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: AppColors.whiteColor,
    leading: AppIcons.arrowback_black,
  );
}
