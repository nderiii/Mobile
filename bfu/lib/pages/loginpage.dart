import 'package:bfu/pages/signuppage.dart';
import 'package:bfu/services/supabase_apis.dart';
import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/gestures.dart';
import 'dashboard.dart';

class Loginpage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();

  Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with overlay
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('images/BFU.png', fit: BoxFit.cover),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo or Title Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: const Icon(Icons.lock_outline, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                   const SizedBox(height: 8),
                  Text(
                    "Login to access your portfolio",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: FormBuilder(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Email
                          FormBuilderTextField(
                            name: 'email',
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'hello@example.com',
                              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4CAF50)),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                              ),
                              floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                             validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          const SizedBox(height: 20),
                          // Password
                          FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4CAF50)),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                              ),
                               floatingLabelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                            ),
                             validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Forgot password logic
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Login Button
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.saveAndValidate()) {
                                  final data = formKey.currentState!.value;
                                  
                                  // Show loading or disable button here ideally
                                  
                                  bool success = await SupabaseApis().signIUser(
                                    data['email'],
                                    data['password'],
                                  );

                                  if (success) {
                                      if(context.mounted) {
                                         ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Login Successful'),
                                            backgroundColor: Color(0xFF2E7D32),
                                          ),
                                        );
                                        Future.delayed(const Duration(milliseconds: 500), () {
                                            if(context.mounted) {
                                               Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => const DashboardPage(),
                                                ),
                                              );
                                            }
                                        });
                                      }
                                  } else {
                                      if(context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Login failed. Check your credentials.'),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                           // Divider
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("OR", style: TextStyle(color: Colors.grey)),
                              ),
                              Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                            ],
                          ),
                           const SizedBox(height: 30),
                          
                          // Sign Up
                           Center(
                             child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
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
                           ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
