class ApiConstants {
  // headers
  static const acceptType = 'application/json';
  static const contentType = 'application/json';

  // base uri
  static const baseUrl = 'https://test-bot.eazzypay.co.zw/api/';

  // static const baseUrl = 'http://192.168.158.53:8000/api/';

  // endpoints
  static const login = '${baseUrl}login';

  static const transactionHistory = '${baseUrl}transaction-history';

  static const agentBalance = '${baseUrl}agent-balance';

  static const lastTransaction = '${baseUrl}last-transaction';

  static const dayTransactions = '${baseUrl}daily-transaction-history';

  static const makePayment = '${baseUrl}payment';

  static const makeTeloneDirectPayment = '${baseUrl}telone-direct-purchase';

  static const teloneProducts = '${baseUrl}telone-products';

  static const teloneProductStocks = '${baseUrl}telone-product-stocks';

  static const netoneProductStocks = '${baseUrl}netone-stocks';

  static const agentFloat = '${baseUrl}float/top-up';

  static const econetBundles = '${baseUrl}bundles/econet';
}
