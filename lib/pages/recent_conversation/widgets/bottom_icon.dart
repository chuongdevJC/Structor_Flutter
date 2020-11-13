import 'dart:io';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';

class BottomIcon extends StatelessWidget {
  final VoidCallback onTapEmoji;
  final VoidCallback onSendButton;
  final VoidCallback onSelectedPhoto;
  final VoidCallback onSelectedEmoji;
  final TextEditingController textFieldController;

  BottomIcon({
    this.onSelectedPhoto,
    this.textFieldController,
    this.onSelectedEmoji,
    this.onSendButton,
    this.onTapEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          IconButton(
            icon: AppIcons.widgets_blue,
            onPressed: null,
          ),
          IconButton(
            icon: AppIcons.camera,
            onPressed: null,
          ),
          IconButton(
              icon: AppIcons.add_photo_alternate_outlined,
              onPressed: onSelectedPhoto),
          Expanded(
            child: TextField(
              controller: textFieldController,
              onTap: onTapEmoji,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0.0),
                hintText: 'Type a message',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                ),
                counterText: '',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 100,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0.0),
            splashColor: Colors.white,
            hoverColor: Colors.white,
            highlightColor: Colors.white,
            disabledColor: Colors.grey,
            color: AppColors.blue,
            icon: Icon(Icons.emoji_emotions_outlined),
            onPressed: onSelectedEmoji,
          ),
          IconButton(
            icon: AppIcons.send_blue,
            onPressed: onSendButton,
          ),
        ],
      ),
    );
  }
}
