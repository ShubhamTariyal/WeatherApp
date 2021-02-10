import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'alertDialog.dart';

void showEnablePermissionDialogue(String message, BuildContext context) {
  showAlertDialog(
    context: context,
    content: message,
    buttonList: [
      FlatButton(
        onPressed: () async {
          await Geolocator.openAppSettings();
          Navigator.pop(context);
          },
        child: Text('Yes'),
      )
    ],
  );
}
