import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Loginpage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  // const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Login Page')));
  }
}
