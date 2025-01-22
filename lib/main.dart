import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insight/body/homepage.dart';
import 'package:insight/intro/SignUpPage.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/intro/forget_password_page.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:insight/body/Project_class.dart' as projectClass;
import 'package:insight/body/Home/AllProjects.dart';
import 'package:insight/body/Home/AddProject.dart';
import 'package:insight/body/Home/Catagories.dart';
import 'package:insight/body/Home/MyProjects.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ProjectViewModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return Homepage();
            } else {
              return Login();
            }
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => SignUpPage(),
        '/forgetPassword': (context) => ForgetPassword(),
        '/homepage': (context) => Homepage(),
      },
    );
  }
}
