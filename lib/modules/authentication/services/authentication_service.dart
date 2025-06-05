import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants/api_constants.dart';

class AuthenticationService {
  Future<http.Response> auth(Map<String, String> data) async {
    return await http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
        "accept": ApiConstants.acceptType,
        "mimeType": ApiConstants.acceptType,
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> test(Map<String, String> data) async {
    var headers = {
      'x-api-key':
          '8a6408c6818c0f59175a665c600c3ea5c4036c6e9bc7af3474c2400dce693469',
      'Content-Type': 'application/json',
      'accept': ApiConstants.acceptType,
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.login));
    request.fields.addAll(data);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
    return http.Response.fromStream(response);
  }
}
