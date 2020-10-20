import 'package:flutter/material.dart';

import 'widgets/allow_profile.dart';
import 'widgets/avatar.dart';
import 'widgets/choice_birthday.dart';
import 'widgets/logout_button.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  bool isPersonalSwitched = false;
  bool isExternalSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileAvatar(),
          Container(
            margin: EdgeInsets.all(12.0),
            alignment: Alignment.topLeft,
            child: Text('SETTING'),
          ),
          AllowProfile('Allow Personal'),
          AllowProfile('Allow External'),
          ChoiceBirthday(),
          LogoutButton(),
        ],
      ),
    );
  }
}
