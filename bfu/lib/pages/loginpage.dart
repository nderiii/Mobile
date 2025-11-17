import 'package:bfu/pages/signuppage.dart';
import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/gestures.dart';

class Loginpage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Container(
              width: double.infinity,
              height: 810,
              child: Image.asset('images/BFU.png', fit: BoxFit.cover),
            ),
            Container(
              width: double.infinity,
              height: 810,
              color: Colors.grey.withOpacity(0.4),
            ),
            // Login form
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(height: 180),
                    TextWidget(
                      text: "Login to BFU",
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                      fontsize: 24,
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                    SizedBox(height: 24),
                    FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          // Email
                          FormBuilderTextField(
                            name: 'email',
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@email.com',
                              prefixIcon: Icon(Icons.mail),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    255,
                                    82,
                                    178,
                                    126,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            cursorColor: const Color.fromARGB(
                              255,
                              82,
                              178,
                              126,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          SizedBox(height: 16),
                          // Password
                          FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(
                                    255,
                                    82,
                                    178,
                                    126,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            cursorColor: const Color.fromARGB(
                              255,
                              82,
                              178,
                              126,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),
                          SizedBox(height: 24),
                          // Login button
                          ButtonWidget(
                            onPressed: () {
                              if (formKey.currentState!.saveAndValidate()) {
                                final data = formKey.currentState!.value;
                                print('Login Data: $data');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login Successful')),
                                );
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                });
                              }
                            },
                            text: 'Login',
                            width: double.infinity,
                            height: 50,
                            color: const Color.fromARGB(255, 82, 178, 126),
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 24),
                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  thickness: 1,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                'OR',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  thickness: 1,
                                  indent: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // Sign up link
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      2,
                                      110,
                                      53,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUpPage(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
