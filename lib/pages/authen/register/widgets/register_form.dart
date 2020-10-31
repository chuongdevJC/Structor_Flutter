import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/authen/login/login_screen.dart';
import 'package:structure_flutter/pages/authen/register/widgets/email_form.dart';
import 'package:structure_flutter/pages/authen/register/widgets/password_form.dart';
import 'package:structure_flutter/widgets/snackbar_widget.dart';
import 'register_button.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _snackBar = getIt<SnackBarWidget>();
  final _registerBloc = getIt<RegisterBloc>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        _snackBar.buildContext = context;
        if (state.isFailure) {
          _snackBar.failure('Register failure !');
        }
        if (state.isSubmitting) {
          _snackBar.submitting('Register ...');
        }
        if (state.isSuccess) {
          _snackBar.success('Register successful !');
          Timer(Duration(seconds: 2), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          });
        }
      },
      child: BlocBuilder(
        cubit: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  EmailForm(state, _emailController),
                  PasswordForm(state, _passwordController),
                  RegisterButton(_emailController, _passwordController, _registerBloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
