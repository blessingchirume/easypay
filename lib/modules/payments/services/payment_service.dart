import 'package:http/http.dart' as http;
class PaymentService {
    Future<http.Response> makepayment(Map<String, String> data) async {
    var headers = {
  'x-api-key': 'd35f5e4f6cd09f23301b777e4bd2f36b876634c84ac2b024e73fed33d17504282'
};
var request = http.MultipartRequest('POST', Uri.parse('https://test-agent.eazzypay.co.zw/api/login'));
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