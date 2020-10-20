import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/text_style.dart';

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPassword = false;
  AuthProvider _auth;

  @override
  void initState() {
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
      height: SizeConstant.screenHeight * 0.3,
      child: Column(
        children: [
          _emailTextField(),
          _passwordTextField(),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return Column(
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
      ],
    );
  }

  Widget _passwordTextField() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          child: Text(
            'Password',
            style: black38_16,
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
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => this.isPassword = !this.isPassword);
              },
              icon: Icon(
                Icons.remove_red_eye,
              ),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
