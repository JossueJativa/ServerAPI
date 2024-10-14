import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getTokenPhone() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Obtener el token de FCM
    String? token = await messaging.getToken();
    return token!;
  } else {
    return '';
  }
}
