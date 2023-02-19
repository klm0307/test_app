import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context,
      {required String text, required bool isSuccess}) {
    final snackBar = SnackBar(
      content: Center(child: Text(text.toUpperCase())),
      backgroundColor: isSuccess ? Colors.green.shade400 : Colors.red.shade400,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
