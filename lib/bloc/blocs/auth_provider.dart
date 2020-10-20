import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:structure_flutter/core/common/enums/authenticate.dart';
import 'file:///G:/Project/jobchat/Structure_Flutter/lib/widgets/snackbar_service.dart';
import 'package:structure_flutter/core/extension/navigation_extension.dart';
import 'package:structure_flutter/repositories/account_repository.dart';

class AuthProvider extends ChangeNotifier {
  User user;
  AuthStatus status;

  FirebaseAuth auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() async {
    if (user != null) {
      await AccountRepositoryImpl.instance.updateUserLastSeenTime(user.uid);
      return NavigationExtension.instance.navigateToReplacement("home");
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await auth.currentUser;
    if (user != null) {
      notifyListeners();
      await _autoLogin();
    }
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _userCredential = await auth.signInWithEmailAndPassword(
          email: "$_email", password: "$_password");
      user = _userCredential.user;
      status = AuthStatus.Authenticated;

      SnackBarWidget.instance.showSnackBarSuccess("Welcome, ${user.email}");
      await AccountRepositoryImpl.instance.updateUserLastSeenTime(user.uid);
      NavigationExtension.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      print("Error Authenticating");
      SnackBarWidget.instance.showSnackBarError("Error Authenticating");
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "$_email", password: "$_password");
      user = _userCredential.user;
      print("VALUE: ${user.uid}");

      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      SnackBarWidget.instance.showSnackBarSuccess("Welcome, ${user.email}");
      await AccountRepositoryImpl.instance.updateUserLastSeenTime(user.uid);
      NavigationExtension.instance.goBack();
      NavigationExtension.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      SnackBarWidget.instance.showSnackBarError("Error Registering User");
    }
    notifyListeners();
  }

  void logoutUser(Future<void> onSuccess()) async {
    try {
      await auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationExtension.instance.navigateToReplacement("login");
      SnackBarWidget.instance.showSnackBarSuccess("Logged Out Successfully!");
    } catch (e) {
      SnackBarWidget.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }
}
