import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getTokenPhone() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    print(token);
    return token!;
  } else {
    return '';
  }
}
