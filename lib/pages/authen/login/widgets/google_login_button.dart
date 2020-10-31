import 'package:flutter/material.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class GoogleLoginButton extends StatelessWidget {
  final _loginBloc = getIt<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: LinearGradient(
              colors: [AppColors.red, AppColors.lightBlueAccentColor]),
          color: AppColors.lightBlueColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.google,
              color: AppColors.white,
            ),
            FlatButton(
              onPressed: () {
                _loginBloc.add(LoginWithGoogle());
              },
              child: Text(
                'SIGN IN WITH GOOGLE',
                style: AppStyles.white_bold_11,
              ),
            ),
          ],
        ));
  }
}
