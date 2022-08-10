import 'package:e_warung/common/styles.dart';
import 'package:flutter/material.dart';

class CustomNotificationSnackbar {
  final BuildContext context;
  final String message;
  final String? actionLabel;
  final Function()? action;

  CustomNotificationSnackbar(
      {required this.context, required this.message, this.actionLabel, this.action}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: colorMenu,
      action: actionLabel == null
          ? null
          : SnackBarAction(label: actionLabel!, textColor: textColorWhite, onPressed: action!),
    ));
  }
}
