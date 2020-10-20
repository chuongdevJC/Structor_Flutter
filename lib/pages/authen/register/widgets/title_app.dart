import 'package:flutter/material.dart';
import '../../../../core/resource/text_style.dart';

class TitleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
      alignment: Alignment.topLeft,
      child: Text(
        'CHAT CHIT',
        style: AppIcons.blue_18,
      ),
    );
  }
}
