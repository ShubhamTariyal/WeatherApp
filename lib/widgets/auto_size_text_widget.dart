import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlexibleText extends StatelessWidget {
  final text;
  final margin;
  final padding;
  final style;
  final maxLines;
  final color;
  final height;
  final width;

  FlexibleText({
    @required this.text,
    this.style,
    this.margin,
    this.padding,
    this.maxLines = 2,
    this.color,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: height,
      width: width,
      alignment: Alignment.center,
      margin: EdgeInsets.all(margin != null ? margin : 5.r),
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        style: style != null ? style : TextStyle(fontSize: 16.h),
        softWrap: true,
        maxLines: maxLines,
      ),
    );
  }
}
