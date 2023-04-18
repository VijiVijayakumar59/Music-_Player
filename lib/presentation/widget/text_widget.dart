import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String commontext;
  final Color selectcolor;
  final double textSize;
  final FontWeight textweight;

  const TextWidget(
      {super.key,
      required this.commontext,
      required this.selectcolor,
      required this.textSize,
      required this.textweight});

  @override
  Widget build(BuildContext context) {
    return Text(
      commontext,
      style: TextStyle(
          color: selectcolor, fontSize: textSize, fontWeight: textweight),
    );
  }
}
