import 'package:flutter/material.dart';

Future<void> showYesNoDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onYes,
  VoidCallback? onNo,
  String yesText = "Yes",
  String noText = "No",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onNo != null) onNo();
            },
            child: Text(noText),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onYes != null) onYes();
            },
            child: Text(yesText),
          ),
        ],
      );
    },
  );
}