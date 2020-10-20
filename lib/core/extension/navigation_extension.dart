import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationExtension {
  GlobalKey<NavigatorState> navigatorKey;

  static NavigationExtension instance = NavigationExtension();

  NavigationExtension() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateTo(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute<Object> _route) {
    return navigatorKey.currentState.push(_route);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
