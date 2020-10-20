import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/authen/login/login_page.dart';

import 'core/common/enums/environment.dart';
import 'main_common.dart';
import 'pages/friend/friend_page.dart';
import 'pages/home/home_page.dart';
import 'pages/setting/setting_page.dart';

// void main() async {
//   await mainCommon(JCEnvironment.DEV);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Scaffold(
      body: SettingPage(),
    ),
  ));
}
