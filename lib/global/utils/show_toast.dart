import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ),
  );
}

void showLoginToast(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("Please login to continue"),
      duration: const Duration(milliseconds: 1500),
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          Navigator.pushNamed(context, "/auth");
        },
      ),
    ),
  );
}
