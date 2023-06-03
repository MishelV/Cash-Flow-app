import 'package:flutter/material.dart';

void navigateBack(BuildContext context) {
  Navigator.of(context).pop();
}

// Function to show an information dialog
void showInformationDialog(BuildContext context, String message,
    {String buttonText = "Nice", Function? onDismiss}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Hurray!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onDismiss != null) {
                onDismiss();
              } else {
                navigateBack(context);
              }
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

// Function to show an error dialog
void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              navigateBack(context);
            },
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}
