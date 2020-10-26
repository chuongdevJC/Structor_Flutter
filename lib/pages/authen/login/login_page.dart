import 'widgets/app_bar.dart';
import 'widgets/button_form.dart';
import 'widgets/checkbox_form.dart';
import 'widgets/input_form.dart';
import 'widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../bloc/blocs/auth_provider.dart';
import '../../../core/common/constants/size_constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConstant.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: Builder(
            builder: (BuildContext _context) {
              return _loginPageUI();
            },
          ),
        ),
      ),
    );
  }

  Widget _loginPageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleApp(),
        Container(
          child: Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState.save();
            },
            child: Column(
              children: [
                InputForm(
                  this.emailController,
                  this.passwordController,
                ),
                CheckBoxForm(),
                ButtonForm(
                  this._formKey,
                  this.emailController,
                  this.passwordController,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
