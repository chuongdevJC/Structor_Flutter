import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/common/enums/authenticate.dart';
import '../../repositories/account_repository.dart';

class AuthProvider extends ChangeNotifier {
  User user;
  AuthStatus status;
  FirebaseAuth auth;
  static final AuthProvider instance = AuthProvider._instance();

  factory AuthProvider() {
    return instance;
  }

  AuthProvider._instance() {
    auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() async {
    if (user != null) {
      return await AccountRepositoryImpl.instance
          .updateUserLastSeenTime(user.uid);
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await auth.currentUser;
    if (user != null) {
      notifyListeners();
      await _autoLogin();
    }
  }

  Future<String> loginUserWithEmailAndPassword(
      String _email, String _password) async {
    status = AuthStatus.Authenticating;
    print('$_email - $_password');
    notifyListeners();
    try {
      UserCredential _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      status = AuthStatus.Authenticated;
      await AccountRepositoryImpl.instance.updateUserLastSeenTime(user.uid);
      return _userCredential.user.uid;
    } catch (e) {
      status = AuthStatus.Error;
      print(e.toString());
      return null;
    }
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
      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      await AccountRepositoryImpl.instance.updateUserLastSeenTime(user.uid);
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
    }
    notifyListeners();
  }

  void logoutUser(Future<void> onSuccess()) async {
    try {
      await auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

}
