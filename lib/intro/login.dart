//import 'package:insight/intro/forget_password_page.dart';
import 'package:flutter/material.dart';
import 'package:insight/intro/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //final FirebaseAuth _auth = FirebaseAuth.instance;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Log In')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text("SignUp"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  color: const Color.fromARGB(255, 10, 186, 180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/forgetPassword');
                          },
                          child: const Text("Forget Password"),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await AuthService().login(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context);
                          },
                          child: const Text('Log In'),
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
    );
  }
}
