import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  AuthProvider _auth;

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    SizeConstant().init(context);
    return Container(
      height: SizeConstant.screenHeight * 0.75,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Email',
                style: black38_16,
              ),
            ),
            TextFormField(
              controller: _emailController,
              validator: (_input) {
                return _input.length != 0 && _input.contains("@")
                    ? null
                    : "Please enter a valid email";
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Password',
                style: TextStyle(color: Colors.black38, fontSize: 16.0),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              autocorrect: false,
              obscureText: true,
              validator: (_input) {
                return _input.length != 0 ? null : "Please enter a password";
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.security),
              ),
              keyboardType: TextInputType.text,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Confirm Password',
                style: black38_16,
              ),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              autocorrect: false,
              obscureText: true,
              validator: (_input) {
                return _input.length != 0
                    ? null
                    : "Please enter a confirm password";
              },
              decoration: InputDecoration(
                hintText: 'Enter your confirm password',
                prefixIcon: Icon(Icons.security),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.remove_red_eye,
                  ),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              width: SizeConstant.screenWidth * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                gradient: LinearGradient(colors: [
                  blueNormalColor,
                  lightBlueAccentColor
                ]),
                color: lightBlueColor,
              ),
              child: FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _auth.registerUserWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        null);
                    // print(_auth.userCredential);
                  }
                },
                child: Text(
                  'Sign Up',
                  style: white_none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
