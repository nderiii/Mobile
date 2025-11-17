import 'package:bfu/services/supabase_apis.dart';
import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/gestures.dart';
import 'loginpage.dart';

class SignUpPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            SizedBox(
              width: double.infinity,
              height: 810,
              child: Image.asset('images/BFU.png', fit: BoxFit.cover),
            ),
            Container(
              width: double.infinity,
              height: 810,
              color: Colors.grey.withOpacity(0.4),
            ),
            // Form content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(height: 150),
                    // Title
                    TextWidget(
                      text: 'Create an Account',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontsize: 24,
                      align: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    // Form
                    FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          // Username
                          FormBuilderTextField(
                            name: 'username',
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter Your Username',
                              prefixIcon: Icon(Icons.person),
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
                              FormBuilderValidators.minLength(3),
                            ]),
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(height: 16),
                          // Confirm Password
                          FormBuilderTextField(
                            name: 'confirm_password',
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                            validator: (val) {
                              final password = formKey
                                  .currentState
                                  ?.fields['password']
                                  ?.value;
                              if (val != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          // Register Button
                          ButtonWidget(
                            onPressed: () {
                              if (formKey.currentState!.saveAndValidate()) {
                                final data = formKey.currentState!.value;
                                print('Registration Data: $data');

                                // call my supabase api function
                                SupabaseApis().createUser(
                                  data['email'],
                                  data['password'],
                                  data['confirm_password'],
                                );
                              }
                            },
                            text: 'Register',
                            width: double.infinity,
                            height: 50,
                            color: const Color.fromARGB(255, 82, 178, 126),
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 30),
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
                          SizedBox(height: 20),
                          // Login link
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      82,
                                      178,
                                      126,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Loginpage(),
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
