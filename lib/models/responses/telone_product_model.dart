class TeloneProductModel {
  int? productId;
  String? name;
  int? accountTypeId;
  List<RequiredOptions>? requiredOptions;
  MetaData? metaData;

  TeloneProductModel(
      {this.productId,
        this.name,
        this.accountTypeId,
        this.requiredOptions,
        this.metaData});

  TeloneProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    accountTypeId = json['accountTypeId'];
    if (json['requiredOptions'] != null) {
      requiredOptions = <RequiredOptions>[];
      json['requiredOptions'].forEach((v) {
        requiredOptions!.add(new RequiredOptions.fromJson(v));
      });
    }
    metaData = json['metaData'] != null
        ? new MetaData.fromJson(json['metaData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['accountTypeId'] = accountTypeId;
    if (requiredOptions != null) {
      data['requiredOptions'] =
          requiredOptions!.map((v) => v.toJson()).toList();
    }
    if (metaData != null) {
      data['metaData'] = metaData!.toJson();
    }
    return data;
  }
}

class RequiredOptions {
  String? name;
  String? parameterType;
  String? description;

  RequiredOptions({this.name, this.parameterType, this.description});

  RequiredOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    parameterType = json['parameterType'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['parameterType'] = parameterType;
    data['description'] = description;
    return data;
  }
}

class MetaData {
  String? stockQuery;
  String? targetInfo;
  String? rechargeType;
  String? accountQuery;
  String? customSMSTagBundle;
  String? targetType;
  String? currency;
  String? network;
  String? rechargeTypeInformation;

  MetaData(
      {this.stockQuery,
        this.targetInfo,
        this.rechargeType,
        this.accountQuery,
        this.customSMSTagBundle,
        this.targetType,
        this.currency,
        this.network,
        this.rechargeTypeInformation});

  MetaData.fromJson(Map<String, dynamic> json) {
    stockQuery = json['StockQuery'];
    targetInfo = json['TargetInfo'];
    rechargeType = json['RechargeType'];
    accountQuery = json['AccountQuery'];
    customSMSTagBundle = json['CustomSMSTagBundle'];
    targetType = json['TargetType'];
    currency = json['Currency'];
    network = json['Network'];
    rechargeTypeInformation = json['RechargeTypeInformation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StockQuery'] = stockQuery;
    data['TargetInfo'] = targetInfo;
    data['RechargeType'] = rechargeType;
    data['AccountQuery'] = accountQuery;
    data['CustomSMSTagBundle'] = customSMSTagBundle;
    data['TargetType'] = targetType;
    data['Currency'] = currency;
    data['Network'] = network;
    data['RechargeTypeInformation'] = rechargeTypeInformation;
    return data;
  }
}
