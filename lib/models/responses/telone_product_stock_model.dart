class TeloneProductStockModel {
  int? productId;
  String? name;
  String? productCode;
  String? description;
  int? amount;
  String? currency;
  int? walletTypeId;

  TeloneProductStockModel(
      {this.productId,
        this.name,
        this.productCode,
        this.description,
        this.amount,
        this.currency,
        this.walletTypeId});

  TeloneProductStockModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    productCode = json['productCode'];
    description = json['description'];
    amount = json['amount'];
    currency = json['currency'];
    walletTypeId = json['walletTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['productCode'] = this.productCode;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['walletTypeId'] = this.walletTypeId;
    return data;
  }
}
