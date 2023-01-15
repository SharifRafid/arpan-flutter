import 'package:flutter/material.dart';
import 'package:Arpan/global/utils/router.dart';
import 'package:Arpan/modules/auth/login_screen.dart';

import '../../main.dart';

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 3500),
    ),
  );
}

void showLoginToast(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("Please login to continue"),
      duration: const Duration(milliseconds: 3500),
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.login,
                (route) => route.isCurrent,
          );
        },
      ),
    ),
  );
}
