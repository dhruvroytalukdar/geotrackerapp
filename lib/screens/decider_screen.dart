import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geotrackerapp/screens/home_screen.dart';
import 'package:geotrackerapp/screens/login_screen.dart';
import 'package:geotrackerapp/screens/register_screen.dart';
import 'package:geotrackerapp/utils/auth.dart';
import 'package:provider/provider.dart';

class DeciderScreen extends StatelessWidget {
  const DeciderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authInstance = context.watch<User?>();
    final screenState = context.watch<AuthenticationService>().screenState;

    if (authInstance != null) return const HomeScreen();
    if (screenState == "register") return const RegisterScreen();
    return const LoginScreen();
  }
}
