import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontsize;
  // final double height;

  const TextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.fontsize,
    // required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontsize,
        // height: height,
      ),
    );
  }
}
