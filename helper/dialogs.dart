import 'package:flutter/material.dart';

class Dialogs {
  static void showSnapbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.black,
        //blue.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()),);
  }
}
