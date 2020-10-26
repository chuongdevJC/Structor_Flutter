import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../bloc/blocs/auth_provider.dart';
import '../../../core/resource/app_colors.dart';
import 'widgets/app_bar.dart';
import 'widgets/input_form.dart';
import 'widgets/title_app.dart';

class RegisterPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _loginPageUI(),
        ),
      ),
    );
  }

  Widget _loginPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleApp(),
            InputForm(),
          ],
        );
      },
    );
  }

}