import 'dart:convert';

import 'package:http/http.dart' as http;

class FitbitRepository {
  Future<Map<String, dynamic>> getTokensByAuthorizationcode({
    required String codeVerifier,
    required String code,
  }) async {
    const String clientID = '23843J';
    const String grantType = 'authorization_code';
    const String contentType = 'application/x-www-form-urlencoded';
    const String secret =
        'MjM4NDNKOjUwZTFjZDhkZGFlMTZmZjAxOWQyZjdiMTg5MzhlMzA0';

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.fitbit.com/oauth2/token?client_id=$clientID&grant_type=$grantType&code=$code&code_verifier=$codeVerifier'),
        headers: <String, String>{
          'Content-Type': contentType,
          'Authorization': 'Basic $secret'
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);

      return data;
    } catch (e) {
      return {'error_Message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getAccessTokenByRefreshToken({
    required String refreshToken,
  }) async {
    const String contentType = 'application/x-www-form-urlencoded';
    const String secret =
        'MjM4NDNKOjUwZTFjZDhkZGFlMTZmZjAxOWQyZjdiMTg5MzhlMzA0';

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.fitbit.com/oauth2/token?grant_type=refresh_token&refresh_token=$refreshToken&expires_in=28800'),
        headers: <String, String>{
          'Content-Type': contentType,
          'Authorization': 'Basic $secret',
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);

      return data;
    } catch (e) {
      return {'error_Message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCurrentHeartRate({
    required String userId,
    required String date,
    required String start,
    required String end,
    required String accessToken,
  }) async {
    try {
      print(
          'https://api.fitbit.com/1/user/$userId/activities/heart/date/$date/1d/1min/time/$start/$end.json');
      final response = await http.get(
        Uri.parse(
            'https://api.fitbit.com/1/user/$userId/activities/heart/date/$date/1d/1min/time/$start/$end.json'),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      );

      final Map<String, dynamic> data = json.decode(response.body);

      print(data);

      return data;
    } catch (e) {
      print(e);
      return {'error_Message': e.toString()};
    }
  }
}
