import 'package:bfu/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:bfu/pages/signuppage.dart';
import 'package:bfu/pages/loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpPage());
  }
}
