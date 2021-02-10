import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'alertDialog.dart';

void showEnableGPSDialoge(BuildContext context) {
  showAlertDialog(
    context: context,
    content: 'Turn on GPS?',
    buttonList: [
      FlatButton(
        onPressed: () async {
          await Geolocator.openLocationSettings();
          Navigator.pop(context);
          },
        child: Text('Yes'),
      )
    ],
  );
}
