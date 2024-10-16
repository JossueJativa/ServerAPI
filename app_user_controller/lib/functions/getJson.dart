import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadAuthData() async {
  // Cargar el archivo auth.json como una cadena de texto
  String jsonString = await rootBundle.loadString('assets/auth.json');

  // Convertir el contenido JSON a un Map<String, dynamic>
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  return jsonData;
}
