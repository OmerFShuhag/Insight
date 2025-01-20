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

  @override
  void initState() {
    super.initState();
    _checkLogIn();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Check if the user is already logged in
  void _checkLogIn() {
    AuthService().authStateChanges.listen((user) {
      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/homepage');
      }
    });
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
                _buildFooterText(),
                const SizedBox(height: 10),
                _buildGoogleLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for top navigation buttons (Login and SignUp)
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

  // Widget for the password input field
  Widget _buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
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
      child: const Text("Forget Password"),
    );
  }

  // Widget for the login button
  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
      },
      child: const Text('Log In'),
    );
  }

  // Widget for footer text
  Widget _buildFooterText() {
    return const Column(
      children: [
        Text('Already have an account? Login'),
        SizedBox(height: 10),
        Text('Or'),
      ],
    );
  }

  // Widget for Google login button
  Widget _buildGoogleLoginButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle Google sign-in
      },
      icon: const Icon(Icons.g_translate),
      label: const Text('Continue With Google'),
    );
  }
}
