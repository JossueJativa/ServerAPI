import 'package:app_user_controller/pages/authPage.dart';
import 'package:app_user_controller/pages/homePage.dart';
import 'package:app_user_controller/pages/housePage.dart';
import 'package:app_user_controller/pages/registerPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const AuthPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/house': (context) => HousePage(
          houseId: ModalRoute.of(context)!.settings.arguments as int,
        ),
      },
      initialRoute: '/',
    );
  }
}