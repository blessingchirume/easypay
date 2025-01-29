import '../modules/authentication/controller/authentication_controller.dart';

class HttpHelper {
  Future<Map<String, String>?>  setHttpHeaders() async {
    return {
      "Content-Type": "application/json",
      "x-api-key": "d35f5e4f6cd09f23301b777e4bd2f36b876634c84ac2b024e73fed33d17504282",
      "Authorization": await AuthenticationController().retrieveAuthToken()
    };
  }
}