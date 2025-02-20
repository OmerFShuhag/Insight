import 'package:flutter/material.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  bool isSignUpSelected = false;

  Widget _buildTopNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isSignUpSelected = false;
              Navigator.pushReplacementNamed(context, '/login');
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: isSignUpSelected ? Colors.white : const Color(0xFF0ABAB5),
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: isSignUpSelected ? Colors.grey[700] : Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 5),
        TextButton(
          onPressed: () {
            setState(() {
              isSignUpSelected = true;
              Navigator.pushReplacementNamed(context, '/signup');
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: isSignUpSelected ? const Color(0xFF0ABAB5) : Colors.white,
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: isSignUpSelected ? Colors.white : Colors.grey[700],
            ),
          ),
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
            ]
            //crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'cse_id@lus.ac.bd',
        labelText: 'Email',
        labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255)),
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

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 15, 105, 96), width: 2),
          ),
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
          errorStyle: const TextStyle(
              color: Colors.red,
            fontSize: 12,
            overflow: TextOverflow.clip,
          ),
          errorMaxLines: 2,
        ),
        validator: (value) {
          return Validators.validatePassword(value ?? '');
        },
      ),
    );
  }

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
