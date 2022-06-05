import 'package:flutter/material.dart';
import 'package:geotrackerapp/screens/decider_screen.dart';
import 'package:geotrackerapp/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geotrackerapp/screens/login_screen.dart';
import 'package:geotrackerapp/screens/register_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/decider',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/decider': (context) => const DeciderScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
