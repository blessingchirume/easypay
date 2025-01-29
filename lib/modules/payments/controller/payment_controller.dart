import 'package:easypay/constants/api_constants.dart';
import 'package:easypay/modules/payments/services/payment_service.dart';
import 'package:easypay/services/api_pipeline_service.dart';
import 'package:http/http.dart';

class PaymentController {
  Future<Response> makepayment(Map<String, String> data) async {
    var response =
        await ApiPipelineService().post(ApiConstants.makepayment, data);

    if (response.statusCode == 200) {
      // var user = UserModel.fromJson(jsonDecode(response.body)['success']);
      // var token = "Bearer ${jsonDecode(response.body)['success']['token']}";
      // saveAuthToken(token);
      // saveUserData(user);
    }

    return response;
  }
}
