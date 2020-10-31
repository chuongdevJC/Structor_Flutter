import 'package:flutter/material.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class RegisterButton extends StatelessWidget {
  final RegisterBloc _registerBloc;

  final TextEditingController _emailController;

  final TextEditingController _passwordController;

  RegisterButton(
    this._emailController,
    this._passwordController,
    this._registerBloc,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        gradient: LinearGradient(colors: [
          AppColors.blueAccentColor,
          AppColors.lightBlueAccentColor
        ]),
        color: AppColors.lightBlueColor,
      ),
      child: FlatButton(
        onPressed: () => registerSubmitted(),
        child: Text(
          'REGISTER',
          style: AppStyles.white_bold_11,
        ),
      ),
    );
  }

  void registerSubmitted() {
    _registerBloc.add(RegisterWithCredentials(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
