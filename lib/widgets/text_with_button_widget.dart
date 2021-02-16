import 'package:flutter/material.dart';

import 'auto_size_text_widget.dart';

class TextWithButton extends StatelessWidget {
  final text;
  final style;
  final handler;

  TextWithButton({
    @required this.text,
    this.style = const TextStyle(fontSize: 16) ,
    this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlexibleText(
          text: text,
          style: TextStyle(fontSize: 30),
        ),
        FlatButton(
          child: Text(
            'Try Again',
            style: TextStyle(fontSize: 20),
          ),
          // elevation: 5,
          textColor: Colors.blue,
          onPressed: handler,
        ),
      ],
    );
  }
}
