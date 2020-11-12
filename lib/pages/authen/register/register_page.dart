import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/icon_style.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/pages/authen/login/login_page.dart';
import 'package:structure_flutter/pages/authen/register/widgets/register_widget.dart';
import 'package:structure_flutter/widgets/app_bar_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegisterPage> {
  final _registerBloc = getIt<RegisterBloc>();

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: Text(
          'Register',
          style: AppStyles.white_10,
        ),
        backgroundColor: AppColors.white_10,
        isCenterTitle: false,
        elevation: 0,
        iconButton: IconButton(
          icon: AppIcons.arrowBack,
          color: AppColors.blue,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage())),
        ),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => _registerBloc,
        child: RegisterWidget(),
      ),
    );
  }
}
