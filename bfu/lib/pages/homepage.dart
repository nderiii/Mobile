import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:bfu/pages/signuppage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: TextWidget(
              text: "Welcome to BFU",
              color: Color.fromARGB(255, 12, 0, 0),
              fontWeight: FontWeight.bold,
              fontsize: 30,
            ),
          ),
          TextWidget(
            text:
                'Welcome to BFU where we make all your crypto trades possible ',
            color: Color.fromARGB(255, 7, 7, 7),
            fontWeight: FontWeight.normal,
            fontsize: 12,
          ),

          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 120),
            child: Center(
              child: Image.asset('images/BFU.png', width: 300, height: 300),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: ButtonWidget(
              text: 'Get Started',
              width: double.infinity,
              height: 50,
              color: const Color.fromARGB(255, 82, 178, 126),
              fontWeight: FontWeight.bold,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
