import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessageBubble extends StatelessWidget {
  bool isOwnMessage;
  String message;
  Timestamp timestamp;

  TextMessageBubble(
    this.isOwnMessage,
    this.message,
    this.timestamp,
  );

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [AppColors.elm, AppColors.elm]
        : [AppColors.double_spanish_white, AppColors.double_spanish_white];

    return Expanded(
      child: Container(
        height: 100,
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              message,
              style: AppStyles.white,
            ),
            Text(
              timeago.format(timestamp.toDate()),
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
