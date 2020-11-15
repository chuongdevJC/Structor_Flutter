import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/di/injection.dart';

class SplashPage extends StatelessWidget {
  final _authenBloc = getIt<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    _authenBloc.add(AppStarted());
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Chat chit',
                    style: AppStyles.black_24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
