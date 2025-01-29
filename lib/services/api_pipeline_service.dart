import 'dart:convert';

import 'package:easypay/helpers/http_helper.dart';
import 'package:http/http.dart' as http;

class ApiPipelineService {
  Future<http.Response> get(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: await HttpHelper().setHttpHeaders(),
    );
  }

    Future<http.Response> post(String url, Map<String, String> payload) async {
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: await HttpHelper().setHttpHeaders(),
    );
  }
}
