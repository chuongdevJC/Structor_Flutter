import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';

class TransitionSendIcon extends StatelessWidget {
  double translateX = 0;
  double translateY = 0;
  double rotate = 0;
  double scale = 1;

  TransitionSendIcon({
    this.translateX,
    this.translateY,
    this.rotate,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      child: Icon(
        Icons.send,
        color: AppColors.white,
      ),
      curve: Curves.fastOutSlowIn,
      transform: Matrix4.translationValues(translateX, translateY, 0)
        ..rotateZ(rotate)
        ..scale(scale),
    );
  }
}
