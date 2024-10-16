import 'dart:convert';

import 'package:app_user_controller/functions/getJson.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getHomes() async {
  final Map<String, dynamic> data = await loadAuthData();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('accessToken');

  final List<String> tokenParts = token!.split('.');
  final String payload = tokenParts[1];
  final String normalizedPayload = base64Url.normalize(payload);
  final String payloadMap = utf8.decode(base64Url.decode(normalizedPayload));
  final Map<String, dynamic> payloadData = json.decode(payloadMap);
  final int userId = payloadData['user_id'];

  final url = data['url'] + '/home_user/?user=$userId';
  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData['home'];
  }

  return [];
}

Future<Map<String, dynamic>> getHome(int id) async {
  final Map<String, dynamic> data = await loadAuthData();

  final url = data['url'] + '/home/$id/';
  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  }

  return {};
}

Future<bool> addNewHouse(
    String urlHA, String tokenHA, int area, String helpBtn) async {
  final Map<String, dynamic> body = {
    'HomeAssistant_Url': urlHA,
    'HomeAssistant_Token': tokenHA,
    'help_btn': helpBtn,
    'area': area.toInt(),
  };

  final Map<String, dynamic> data = await loadAuthData();

  final url = data['url'] + '/home/';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(body),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final int homeId = responseData['id'];
    final bool isAdded = await _addHomeToUser(homeId);
    return isAdded;
  }

  return false;
}

Future<bool> _addHomeToUser(int homeId) async {
  final Map<String, dynamic> data = await loadAuthData();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('accessToken');

  final List<String> tokenParts = token!.split('.');
  final String payload = tokenParts[1];
  final String normalizedPayload = base64Url.normalize(payload);
  final String payloadMap = utf8.decode(base64Url.decode(normalizedPayload));
  final Map<String, dynamic> payloadData = json.decode(payloadMap);
  final int userId = payloadData['user_id'];

  final url = data['url'] + '/home_user/';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'home': homeId,
      'user': userId,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  }

  return false;
}

Future<Map<int, String>> getAreas() async {
  Map<int, String> areas = {};

  final Map<String, dynamic> data = await loadAuthData();

  final url = data['url'] + '/area/';
  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    for (int i = 0; i < responseData.length; i++) {
      areas[responseData[i]['id']] = responseData[i]['name'];
    }
    return areas;
  }

  return areas;
}

Future<bool> sendMessage(int homeId, String message) async {
  final Map<String, dynamic> data = await loadAuthData();

  final url = data['url'] + '/home/send_message/';

  final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'homeId': homeId, 'message': message}));

  if (response.statusCode == 200) {
    return true;
  }

  return false;
}
