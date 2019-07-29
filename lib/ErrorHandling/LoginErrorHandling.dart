import 'package:flutter/material.dart';
import '../widgets/LoginErrorDialogBox.dart';

class LoginErrorHandling {
  BuildContext context;
  String errorCode;

  LoginErrorHandling(this.context, this.errorCode);

  void handleLoginError() {
    switch (errorCode) {
      case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
        showDialog(
            context: this.context,
            builder: (BuildContext context) {
              return LoginErrorDialogBox();
            });
        break;

      default:
        showDialog(
            context: this.context,
            builder: (BuildContext context) {
              return LoginErrorDialogBox();
            });
        break;
    }
  }
}
