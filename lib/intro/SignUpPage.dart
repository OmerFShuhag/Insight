//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:insight/validators.dart';
import 'auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Log In'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Remain on the current screen
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Color(0xFF0ABAB5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return Validators.validateName(value ?? '');
                            },
                          ),
                          // const SizedBox(height: 10),
                          // TextFormField(
                          //   autovalidateMode:
                          //       AutovalidateMode.onUserInteraction,
                          //   controller: phoneController,
                          //   decoration: const InputDecoration(
                          //     labelText: 'Phone Number',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return Validators.validateEmail(value ?? '');
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return Validators.validatePassword(value ?? '');
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return Validators.validateConfirmPassword(
                                value ?? '',
                                passwordController.text,
                              );
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),

                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await AuthService().signup(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                            },
                            child: const Text('SIGN UP'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Already have an account? Login'),
                  const SizedBox(height: 10),
                  const Text('Or'),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google sign up
                    },
                    icon: const Icon(Icons.g_translate),
                    label: const Text('Continue With Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
