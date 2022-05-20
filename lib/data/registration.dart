import 'dart:convert';

import 'package:http/http.dart' as http;

class Registration {
  static Future<String?> signUpRequest(
    String username,
    String email,
    String password,
  ) async {
    var url = Uri.parse('https://api.grustnogram.ru/users');
    var response = await http.post(
      url,
      body: jsonEncode(
        {
          'nickname': username,
          'email': email,
          'password': password,
        },
      ),
    );
    return json.decode(response.body)['data']['access_token'];
  }

  ///Перенесено
  static Future<String?> signInRequest(
    String email,
    String password,
  ) async {
    var url = Uri.parse('https://api.grustnogram.ru/sessions');
    var response = await http.post(
      url,
      body: jsonEncode(
        {
          'email': email,
          'password': password,
        },
      ),
    );
    return json.decode(response.body)['data']['access_token'];
  }


  static Future<void> logOutRequest(String token) async {
    var url = Uri.parse('https://api.grustnogram.ru/sessions/current');
    await http.delete(url, headers: {
      'Access-Token': token,
    });
  }
}
