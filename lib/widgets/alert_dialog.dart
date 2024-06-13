



import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog(context, {required String title, required String description, required Function() navigate, required Function() goBack}) {
    showCupertinoDialog<void>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: goBack,
              ),
              CupertinoDialogAction(
                child: Text("Yes"),
                isDestructiveAction: true,
                onPressed: navigate,
              ),
            ],
          );
        });
  }
}