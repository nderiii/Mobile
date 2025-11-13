import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight fontWeight;
  final double fontsize;
  final TextAlign? align;
  final double? height;
  final Color? backgroundColor;
  // final double height;

  const TextWidget({
    super.key,
    required this.text,
    this.color,
    required this.fontWeight,
    required this.fontsize,
    this.align,
    this.backgroundColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontsize,
      ),
      textAlign: align,
      // height: height,
    );
  }
}
