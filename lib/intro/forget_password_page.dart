import 'package:flutter/material.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/validators.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            padding: const EdgeInsets.all(20.0),
            child: _buildForgetPasswordCard(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPasswordCard(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color.fromARGB(255, 10, 186, 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(height: 20),
              _buildEmailInputField(),
              const SizedBox(height: 20),
              _buildSendResetLinkButton(context),
              const SizedBox(height: 10),
              _buildBackToLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Forget Password',
      style: TextStyle(
        fontSize: 24,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  Widget _buildEmailInputField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 15, 105, 96), width: 2),
        ),
      ),
      validator: (value) {
        return Validators.validateEmail(value ?? '');
      },
    );
  }

  Widget _buildSendResetLinkButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await AuthService().resetPassword(
            email: emailController.text.trim(),
            context: context,
          );
        }
      },
      child: const Text(
        'Send Reset Link',
        style: TextStyle(color: Colors.teal),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text(
        'Back to Login',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
