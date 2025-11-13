import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:bfu/pages/signuppage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: TextWidget(
              text: "Welcome to BFU",
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontsize: 30,
            ),
          ),
          TextWidget(
            text:
                'Welcome to BFU where we make all your crypto trades possible ',
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontsize: 12,
          ),

          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 120),
            child: Center(
              child: Image.asset('images/crypto.jpeg', width: 300, height: 300),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: ButtonWidget(
              text: 'Get Started',
              width: double.infinity,
              height: 50,
              color: const Color.fromARGB(255, 109, 4, 230),
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
