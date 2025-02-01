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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0), child: _buildForm()),
              ),
            ),
          ],
        ));
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeaderButtons(),
          const SizedBox(height: 20),
          _buildSignUpCard(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
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
    );
  }

  Widget _buildSignUpCard() {
    return Card(
      color: Color(0xFF0ABAB5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNameField(),
            const SizedBox(height: 10),
            _buildEmailField(),
            const SizedBox(height: 10),
            _buildPasswordField(),
            const SizedBox(height: 10),
            _buildConfirmPasswordField(),
            const SizedBox(height: 10),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return Validators.validateName(value ?? '');
      },
    );
  }

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

  Widget _buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        return Validators.validatePassword(value ?? '');
      },
      obscureText: true,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signup(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
      },
      child: const Text('SIGN UP'),
    );
  }
}
