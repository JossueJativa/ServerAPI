import 'package:app_user_controller/functions/getJson.dart';
import 'package:http/http.dart' as http;

Future<bool> helpAction(int homeId) async {
  final Map<String, dynamic> jsonAuth = await loadAuthData();
  final String url = jsonAuth['url'] + '/area/HelpBtn/?home_id=$homeId';
  try{
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } 
  catch (e) {
    return false;
  }
  finally {
    return false;
  }
}
