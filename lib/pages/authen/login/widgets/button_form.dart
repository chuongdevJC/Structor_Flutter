import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../../../widgets/navigation_manager.dart';
import '../../../../widgets/snackbar_service.dart';
import '../../../../bloc/blocs/auth_provider.dart';
import '../../../../core/common/constants/size_constant.dart';
import '../../../../core/resource/app_colors.dart';
import '../../../../core/resource/text_style.dart';
import '../../../../pages/home/home_page.dart';

class ButtonForm extends StatefulWidget {
  ButtonForm(this.formKey, this.emailController, this.passwordController);

  GlobalKey<FormState> formKey;
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  _ButtonFormState createState() => _ButtonFormState();
}

class _ButtonFormState extends State<ButtonForm> {
  var userUid;

  @override
  Widget build(BuildContext context) {
    SizeConstant.init(context);
    return Container(
      height: SizeConstant.screenHeight * 0.4,
      child: Column(
        children: [
          Container(
            width: SizeConstant.screenWidth,
            height: SizeConstant.screenHeight * 0.065,
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              gradient: LinearGradient(colors: [
                AppColors.blueAccentColor,
                AppColors.lightBlueAccentColor
              ]),
              color: AppColors.lightBlueColor,
            ),
            child: FlatButton(
              onPressed: () async {
                String email = this.widget.emailController.text.toString().trim();
                String password = this.widget.passwordController.text.toString().trim();
                if (this.widget.formKey.currentState.validate()) {
                  userUid = await AuthProvider.instance.loginUserWithEmailAndPassword(email, password);
                  if (userUid == null) {
                    SnackBarService.instance.showSnackBarError('Login not successful ! ');
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userUid)));
                  }
                }
              },
              child: Text(
                'LOGIN',
                style: AppStyles.white_bold_11,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You don't have a account?"),
              GestureDetector(
                onTap: () {
                  NavigationManager().navigateToRoute(MaterialPageRoute(
                    builder: (context) {
                      return HomePage(userUid);
                    },
                  ));
                },
                child: Container(
                  child: Text(
                    ' Sign up',
                    style: AppStyles.black_none,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: SizeConstant.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: SignInButton(
              Buttons.Facebook,
              onPressed: () {},
            ),
          ),
          Container(
            width: SizeConstant.screenWidth,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: SignInButton(
              Buttons.Google,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

}
