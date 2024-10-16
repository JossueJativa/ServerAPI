import 'dart:convert';

import 'package:app_user_controller/functions/getJson.dart';
import 'package:app_user_controller/functions/tokenPhone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> authCallback(username, password) async {
  final Map<String, dynamic> jsonAuth = await loadAuthData();
  final String url = jsonAuth['url'] + '/user/login/';
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final Map<String, dynamic> body = {
    'username': username,
    'password': password,
  };

  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    String accessToken = responseData['access'];
    String refreshToken = responseData['refresh'];
    String tokenPhone = await getTokenPhone();
    String TokenPhoneUser = responseData['token_phone'];
    int userId = responseData['id'];

    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    if (tokenPhone != TokenPhoneUser) {
      final Map<String, dynamic> body = {
        'token_phone': tokenPhone,
      };

      final response = await http.patch(
          Uri.parse(jsonAuth['url'] + '/user/' + userId.toString() + '/'),
          body: body);

      if (response.statusCode != 200) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
}

Future<bool> registerCallback(
    username, email, password, confirmPassword) async {
  String tokenPhone = await getTokenPhone();
  final Map<String, dynamic> jsonAuth = await loadAuthData();
  final String url = jsonAuth['url'] + '/user/';

  final Map<String, dynamic> body = {
    'username': username,
    'email': email,
    'password': password,
    'token_phone': tokenPhone,
  };

  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> refreshAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? refreshToken = prefs.getString('refreshToken');

  if (refreshToken == null) {
    return false;
  }

  final Map<String, dynamic> jsonAuth = await loadAuthData();
  final String url = jsonAuth['url'] + '/token/refresh/';

  final Map<String, dynamic> body = {
    'refresh': refreshToken,
  };

  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    String newAccessToken = responseData['access'];
    String newRefreshToken = responseData['refresh'];

    await prefs.setString('accessToken', newAccessToken);
    await prefs.setString('refreshToken', newRefreshToken);
    return true;
  } else {
    return false;
  }
}

void removeTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("accessToken");
  prefs.remove("refreshToken");
}

// Ejemplo de uso
// Future<void> someAuthenticatedRequest() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? accessToken = prefs.getString('accessToken');

//   if (accessToken == null) {
//     bool refreshed = await refreshAccessToken();
//     if (!refreshed) {
//       return;
//     }
//     accessToken = prefs.getString('accessToken'); // Obtén el nuevo token de acceso
//   }

//   // Ahora puedes hacer tu solicitud usando el token de acceso
//   final response = await http.get(
//     Uri.parse('https://yourapi.com/protected-resource'),
//     headers: {
//       'Authorization': 'Bearer $accessToken',
//     },
//   );
// }
