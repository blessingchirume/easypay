import 'package:easypay/services/api_pipeline_service.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_constants.dart';

class TransactionController {
  Future<http.Response> getTransactionHistory() async {
    return ApiPipelineService().get(ApiConstants.lastTransaction);
  }

  Future<http.Response> getLastTransaction() async {
    return ApiPipelineService().get(ApiConstants.transactionHistory);
  }

  Future<http.Response> getAgentBalance() async {
    return ApiPipelineService().get(ApiConstants.agentBalance);
  }
}
