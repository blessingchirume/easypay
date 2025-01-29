import 'dart:convert';

import 'package:easypay/modules/authentication/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/http_helper.dart';
import '../../../models/responses/user_response_model.dart';

class AuthenticationController {
  Future<http.Response> auth(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return http.Response("Some fields are empty", 422);
    }

    var response = await AuthenticationService()
        .test({"email": email, "password": password});

    if (response.statusCode == 200) {
      var user = UserModel.fromJson(jsonDecode(response.body));
      var token = "Bearer ${jsonDecode(response.body)['access_token']}";
      saveAuthToken(token);
      saveUserData(user);
    }

    return response;
  }

Future<UserModel> retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('userData').toString();
    return UserModel.fromJson(jsonDecode(data));
  }

  void saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));
  }

  void saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<String> retrieveAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authToken').toString();
    return token;
  }
}


