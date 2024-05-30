import 'dart:math';

import 'package:flutter/material.dart';

abstract class Util {
  static const rad = pi / 180;

  static void showSnackBar(BuildContext context, String message,
      {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
    ));
  }
}