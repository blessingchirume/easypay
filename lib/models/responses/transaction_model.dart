class TransactionModel {
  String? txnType;
  String? account;
  String? amount;
  String? currency;
  String? createdAt;

  TransactionModel(
      {this.txnType, this.account, this.amount, this.currency, this.createdAt});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    txnType = json['txn_type'];
    account = json['account'];
    amount = json['amount'];
    currency = json['currency'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txn_type'] = txnType;
    data['account'] = account;
    data['amount'] = amount;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    return data;
  }
}
