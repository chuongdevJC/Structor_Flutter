import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'widgets/app_bar.dart';
import 'widgets/button_form.dart';
import 'widgets/checkbox_form.dart';
import 'widgets/input_form.dart';
import 'widgets/title_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _loginPageUI(),
        ),
      ),
    );
  }

  Widget _loginPageUI() {
    SizeConstant().init(context);
    return Builder(
      builder: (BuildContext _context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleApp(),
            Container(
              height: SizeConstant.screenHeight*0.8,
              child: Form(
                  key: _formKey,
                  onChanged: () {
                    _formKey.currentState.save();
                  },
                  child: Container(
                    child: Column(
                      children: [
                        InputForm(),
                        CheckBoxForm(),
                        ButtonForm(_formKey),
                      ],
                    ),
                  )),
            )
          ],
        );
      },
    );
  }
}
