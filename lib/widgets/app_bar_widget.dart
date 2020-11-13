import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;
  final bool isCenterTitle;
  final double elevation;
  final IconButton iconButton;
  final Icon leading;
  final List<Widget> actions;

  AppBarWidget({
    this.title,
    this.backgroundColor,
    this.isCenterTitle,
    this.elevation,
    this.iconButton,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      elevation: elevation,
      centerTitle: isCenterTitle,
      backgroundColor: backgroundColor,
      leading: iconButton,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
