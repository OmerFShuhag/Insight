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
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
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
        Card(
          elevation: 5.0,
          color: const Color.fromARGB(255, 22, 197, 183),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Log In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpCard() {
    return Card(
      color: const Color(0xFF0ABAB5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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

  // Widget _buildNameField() {
  //   return TextFormField(
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     controller: nameController,
  //     decoration: const InputDecoration(
  //       labelText: 'Name',
  //       border: OutlineInputBorder(),
  //     ),
  //     validator: (value) {
  //       return Validators.validateName(value ?? '');
  //     },
  //   );
  // }

  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible =
                  !_passwordVisible; // Toggle password visibility
            });
          },
        ),
      ),
      validator: (value) {
        return Validators.validatePassword(value ?? '');
      },
      obscureText: !_passwordVisible,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _confirmPasswordVisible =
                  !_confirmPasswordVisible; // Toggle confirm password visibility
            });
          },
        ),
      ),
      validator: (value) {
        return Validators.validateConfirmPassword(
          value ?? '',
          passwordController.text,
        );
      },
      obscureText:
          !_confirmPasswordVisible, // Hide/show confirm password based on _confirmPasswordVisible
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          await AuthService().signup(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
        }
      },
      child: const Text('SIGN UP'),
    );
  }
}
