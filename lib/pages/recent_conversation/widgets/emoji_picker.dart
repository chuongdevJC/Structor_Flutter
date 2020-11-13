import 'package:emoji_pick/emoji_pick.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';

class EmojiesPicker extends StatelessWidget {
  final double emojiheight;
  final TextEditingController textFieldController;

  EmojiesPicker(this.emojiheight, this.textFieldController);

  @override
  Widget build(BuildContext context) {
    return Emojies(
      tabsname: AppIcons.tabsname,
      tabsemoji: AppIcons.tabsemoji,
      maxheight: emojiheight,
      inputtext: textFieldController,
      bgcolor: Colors.white,
    );
  }
}
