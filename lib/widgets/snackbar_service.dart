import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackBarWidget{
  SnackBarWidget() {}

  BuildContext _buildContext;

  static SnackBarWidget instance = SnackBarWidget();

  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackBarError(String _message) {
    Scaffold.of(_buildContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          _message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSnackBarSuccess(String _message) {
    Scaffold.of(_buildContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          _message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
