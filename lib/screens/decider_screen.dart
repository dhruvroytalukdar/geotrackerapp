import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geotrackerapp/screens/home_screen.dart';
import 'package:geotrackerapp/screens/login_screen.dart';

class DeciderScreen extends StatelessWidget {
  const DeciderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authInstance = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: authInstance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            print("hello");
            return const LoginScreen();
          } else {
            print("hello home");
            return const HomeScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }, //Auth stream
    );
  }
}
