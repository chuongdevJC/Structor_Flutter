import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';

class UserImageWidget extends StatelessWidget {
  String userImage;

  UserImageWidget(this.userImage);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      child: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(userImage),
        backgroundColor: AppColors.outer_space,
      ),
    );
  }
}
