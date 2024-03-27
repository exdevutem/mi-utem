import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';

void showErrorSnackbar(BuildContext context, String message) => showTextSnackbar(context, title: "Error", message: message, backgroundColor: Colors.red);

void showTextSnackbar(BuildContext context, {
  required String title,
  required String message,
  Color? backgroundColor,
  Color? textColor,
  Duration? duration,
}) => showSnackbar(context,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor ?? Colors.white)),
      Text(message, style: TextStyle(color: textColor ?? Colors.white)),
    ],
  ),
  backgroundColor: backgroundColor,
  duration: duration,
);

void showSnackbar(BuildContext context, {
  required Widget content,
  Color? backgroundColor,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    backgroundColor: backgroundColor ?? MainTheme.primaryColor,
    behavior: SnackBarBehavior.floating,
    duration: duration ?? const Duration(seconds: 5),
  ));
}