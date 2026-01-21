import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({super.key, required String message, VoidCallback? onDismiss})
    : super(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            onDismiss?.call();
          },
        ),
      );

  static void show(
    BuildContext context,
    String message, {
    VoidCallback? onDismiss,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(ErrorSnackBar(message: message, onDismiss: onDismiss));
  }
}
