import 'package:flutter/material.dart';
import 'package:geotrackerapp/components/login_screen/content_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ContentSection(),
    );
  }
}
