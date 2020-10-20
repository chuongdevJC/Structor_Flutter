import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure_flutter/bloc/blocs/auth_provider.dart';
import 'package:structure_flutter/core/common/constants/size_constant.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/pages/authen/login/login_page.dart';

class LogoutButton extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    SizeConstant().init(context);
    return Container(
      child: FlatButton(
        color: redColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        onPressed: () {},
        child: Text(
          'LOGOUT',
          style: white_15,
        ),
      ),
    );
  }
}
