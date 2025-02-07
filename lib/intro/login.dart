import 'package:flutter/material.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for email and password input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopNavigation(),
                const SizedBox(height: 20),
                _buildLoginCard(context),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text('Log In'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
          child: const Text("SignUp"),
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color.fromARGB(255, 10, 186, 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailField(),
              const SizedBox(height: 10),
              _buildPasswordField(),
              _buildForgetPasswordButton(context),
              const SizedBox(height: 10),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the email input field
  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return Validators.validateEmail(value ?? '');
      },
    );
  }

  // Widget for the password input field with visibility toggle
  Widget _buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        return Validators.validatePassword(value ?? '');
      },
    );
  }

  // Widget for the forget password button
  Widget _buildForgetPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/forgetPassword');
      },
      child: const Text(
        "Forget Password",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await AuthService().login(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
        }
      },
      child: const Text(
        'Log In',
        style: TextStyle(color: Colors.teal),
      ),
    );
  }
}
