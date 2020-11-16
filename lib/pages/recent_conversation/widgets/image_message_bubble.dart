import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class ImageMessageBubble extends StatelessWidget {
  bool isOwnMessage;
  String imageURL;
  Timestamp timestamp;

  ImageMessageBubble(
    this.isOwnMessage,
    this.imageURL,
    this.timestamp,
  );

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [AppColors.elm, AppColors.elm]
        : [AppColors.double_spanish_white, AppColors.double_spanish_white];
    DecorationImage _image = DecorationImage(image: NetworkImage(imageURL), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          Text(
            timeago.format(timestamp.toDate()),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
