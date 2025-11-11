import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget{
  final String value;
  final double? fontSize;
  final FontWeight? fontWeight;

  const TextWidget({super.key, required this.value, this.fontSize, this.fontWeight});
  

  @override
  Widget build(BuildContext context) {
    return Text(value,style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),);
  }

}
