import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple]),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
