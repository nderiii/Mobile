import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/gestures.dart';
import 'loginpage.dart';

class SignUpPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Purple header section
            SizedBox(height: 50),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 133, 6, 206),
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 24.0,
              ),
              child: TextWidget(
                text: 'BFU',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontsize: 24,
                align: TextAlign.center,
              ),
            ),
            // Title section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextWidget(
                text: 'Create an Account',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontsize: 20,
                align: TextAlign.center,
              ),
            ),

            // Form section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    // Username field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: 'username',
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter Your Username',
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 109, 4, 230),
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        cursorColor: const Color.fromARGB(255, 109, 4, 230),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ]),
                      ),
                    ),

                    // Email field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@email.com',
                          prefixIcon: Icon(Icons.mail),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 109, 4, 230),
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        cursorColor: const Color.fromARGB(255, 109, 4, 230),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                    ),

                    // Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: 'password',
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 109, 4, 230),
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        cursorColor: const Color.fromARGB(255, 109, 4, 230),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ]),
                      ),
                    ),

                    // Confirm Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: 'confirm_password',
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 109, 4, 230),
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        cursorColor: const Color.fromARGB(255, 109, 4, 230),
                        validator: (val) {
                          final password =
                              formKey.currentState?.fields['password']?.value;
                          if (val != password) return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register button
                    ButtonWidget(
                      onPressed: () {
                        if (formKey.currentState!.saveAndValidate()) {
                          final data = formKey.currentState!.value;
                          print('Registration Data: $data');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration Successful')),
                          );
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      text: 'Register',
                      width: double.infinity,
                      height: 50,
                      color: const Color.fromARGB(255, 109, 4, 230),
                      fontWeight: FontWeight.bold,
                    ),

                    SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        Text('OR', style: TextStyle(color: Colors.grey)),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

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
                              color: const Color.fromARGB(255, 102, 10, 223),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
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
