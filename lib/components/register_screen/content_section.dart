import 'package:flutter/material.dart';
import 'package:geotrackerapp/components/register_screen/form_section.dart';
import 'package:geotrackerapp/components/register_screen/top_section.dart';
import 'package:geotrackerapp/utils/auth.dart';
import 'package:provider/provider.dart';

class ContentSection extends StatefulWidget {
  const ContentSection({Key? key}) : super(key: key);

  @override
  State<ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends State<ContentSection> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSubmitting = false;
  String? error;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  changeState(String? errorText) {
    setState(() {
      isSubmitting = !isSubmitting;
      error = errorText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isSubmitting) TopComponent(error: error),
              if (!isSubmitting)
                FormComponent(
                  emailController: emailController,
                  passwordController: passwordController,
                  changeState: changeState,
                ),
              if (isSubmitting) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
