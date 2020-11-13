import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import '../../../core/resource/text_style.dart';

class Avatar extends StatelessWidget {
  final String displayName;
  final String photoUrl;

  Avatar(this.displayName, this.photoUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 41,
          backgroundColor: AppColors.red,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.double_spanish_white,
            backgroundImage: NetworkImage(photoUrl),
          ),
        ),
        Text(displayName, style: AppStyles.font_25),
      ],
    );
  }
}
