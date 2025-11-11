import 'package:base/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.black]),
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              value: "Your Portal to Web3",
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
