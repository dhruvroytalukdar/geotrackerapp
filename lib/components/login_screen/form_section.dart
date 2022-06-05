import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormComponent extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function changeState;
  const FormComponent({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.changeState,
  }) : super(key: key);

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  final _formKey = GlobalKey<FormState>();
  String? error;

  setError(String? text) {
    widget.changeState(text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget.emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            style: const TextStyle(fontSize: 20.0),
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return "The field is empty";
              }
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(text);
              if (emailValid == false) {
                return "The value is not a valid email";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: widget.passwordController,
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
            style: const TextStyle(fontSize: 20.0),
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return "The field is empty";
              }
              if (text.length < 6) {
                return "Please enter a password of minimum length 6";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    widget.changeState(null);
                    String? temp;
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: widget.emailController.text,
                        password: widget.passwordController.text,
                      );
                      temp = null;
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        temp = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        temp = 'The account already exists for that email.';
                      } else if (e.code == "user-not-found") {
                        print('The account does not exists.');
                        temp = 'The account does not exists.';
                      }
                    } catch (e) {
                      print(e.toString());
                      temp = e.toString();
                    }
                    widget.changeState(temp);
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
