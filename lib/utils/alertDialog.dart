import 'package:flutter/material.dart';

showAlertDialog({
  @required BuildContext context,
  @required List<FlatButton> buttonList,
  @required String content,
}) {
  buttonList.add(
    FlatButton(
      child: Text('Cancel'),
      onPressed: () => Navigator.pop(context),
    ),
  );
  AlertDialog alert = AlertDialog(
    content: Text(
      content,
      style: TextStyle(
        fontSize: 20,
      ),
    ),
    actions: buttonList,
  );
  showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}
