import 'package:bfu/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginPage extends StatelessWidget {
  final formKey = GlobalKey<FormBuilderState>();
  // const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
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
                    if (val != password) return 'Password does not match';
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ButtonWidget(
                onPressed: () {
                  if (formKey.currentState!.saveAndValidate()) {
                    final data = formKey.currentState!.value;
                    print('Rgistration Data:$data');

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
            ],
          ),
        ),
      ),
    );
  }
}
