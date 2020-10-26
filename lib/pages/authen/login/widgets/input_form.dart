import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/blocs/auth_provider.dart';
import '../../../../core/common/constants/size_constant.dart';
import '../../../../core/resource/text_style.dart';
import 'package:email_validator/email_validator.dart';

class InputForm extends StatefulWidget {
  InputForm(this.emailController, this.passwordController);

  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    SizeConstant.init(context);
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
            style: AppStyles.black38_16,
          ),
        ),
        TextFormField(
          controller: this.widget.emailController,
          validator: (_input) => EmailValidator.validate(_input)
              ? null
              : "Please enter a valid email",
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
            style: AppStyles.black38_16,
          ),
        ),
        TextFormField(
          controller: this.widget.passwordController,
          autocorrect: false,
          obscureText: _isObscureText,
          validator: (_input) {
            return _input.isNotEmpty ? null : "Please enter a password";
          },
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.security),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => this._isObscureText = !this._isObscureText);
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
