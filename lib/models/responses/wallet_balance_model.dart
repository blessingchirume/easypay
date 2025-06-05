class WalletBalanceModel {
  String? usdBalance;
  String? zwgBalance;

  WalletBalanceModel({required this.usdBalance, required this.zwgBalance});

  WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    usdBalance = json['usd_balance'];
    zwgBalance = json['zwg_balance'];
  }
}
