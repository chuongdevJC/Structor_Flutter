import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/pages/authen/register/register_page.dart';
import 'package:structure_flutter/pages/home/home_page.dart';

class ButtonForm extends StatefulWidget {
  GlobalKey<FormState> formKey;

  ButtonForm(this.formKey);

  @override
  _ButtonFormState createState() => _ButtonFormState(this.formKey);
}

class _ButtonFormState extends State<ButtonForm> {
  GlobalKey<FormState> formKey;
  _ButtonFormState(this.formKey);

  AuthProvider _auth;
  bool isPassword = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    SizeConstant().init(context);
    return Container(
      height: SizeConstant.screenHeight * 0.4,
      child: Column(
        children: [
          Container(
            width: SizeConstant.screenWidth,
            height: SizeConstant.screenHeight * 0.065,
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              gradient: LinearGradient(colors: [
                blueAccentColor,
                lightBlueAccentColor
              ]),
              color: lightBlueColor,
            ),
            child: FlatButton(
                onPressed: () {
                  if (this.formKey.currentState.validate()) {
                    _auth.loginUserWithEmailAndPassword(
                        _emailController.text.toString(),
                        _passwordController.text.toString());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: Text(
                  'LOGIN',
                  style: white_bold_11,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You don't have a account?"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Container(
                  child: Text(
                    ' Sign up',
                    style: black_none,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: SizeConstant.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: SignInButton(
              Buttons.Facebook,
              onPressed: () {},
            ),
          ),
          Container(
            width: SizeConstant.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: SignInButton(
              Buttons.Google,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
