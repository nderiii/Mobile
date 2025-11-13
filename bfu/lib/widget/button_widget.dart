import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.color,
    required this.fontWeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
