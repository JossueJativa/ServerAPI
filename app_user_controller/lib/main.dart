import 'package:app_user_controller/providers/pushNotifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_user_controller/pages/authPage.dart';
import 'package:app_user_controller/pages/registerPage.dart';
import 'package:app_user_controller/pages/homePage.dart';
import 'package:app_user_controller/pages/housePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  PushNotification pushNotification = PushNotification();
  await pushNotification.initNotifications();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

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
