import 'package:e_warung/common/styles.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final Widget title;
  final Widget content;
  final Function() submit;
  const CustomAlertDialog(
      {Key? key, required this.title, required this.content, required this.submit})
      : super(key: key);

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: widget.title,
      content: widget.content,
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: textFieldColorGrey),
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
            onPressed: widget.submit,
            child: const Text('OK', style: TextStyle(color: primaryColor))),
      ],
    );
  }
}
