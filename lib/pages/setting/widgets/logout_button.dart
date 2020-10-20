import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../bloc/blocs/auth_provider.dart';
import '../../../core/common/constants/size_constant.dart';
import '../../../core/resource/app_colors.dart';
import '../../../core/resource/text_style.dart';
import '../../../pages/authen/login/login_page.dart';

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
        color: AppColors.redColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        onPressed: () {},
        child: Text(
          'LOGOUT',
          style: AppIcons.white_15,
        ),
      ),
    );
  }
}
