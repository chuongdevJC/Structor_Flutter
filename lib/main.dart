import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/authen/login/login_page.dart';

// void main() async {
//   await mainCommon(JCEnvironment.DEV);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Scaffold(
      body: LoginPage(),
    ),
  ));
}
