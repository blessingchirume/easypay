class EconetBundleCategoryModel {
  String? name;
  List<EconetBundleModel>? econetBundleModel;

  EconetBundleCategoryModel({this.name, this.econetBundleModel});

  EconetBundleCategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['econet_bundle_model'] != null) {
      econetBundleModel = <EconetBundleModel>[];
      json['econet_bundle_model'].forEach((v) {
        econetBundleModel!.add(EconetBundleModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (econetBundleModel != null) {
      data['econet_bundle_model'] =
          econetBundleModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EconetBundleModel {
  int? id;
  String? bundle;
  String? currency;
  String? mapName;
  double? price;
  String? pricePlanCode;
  String? validity;
  int? volume;

  EconetBundleModel(
      {this.id,
        this.bundle,
        this.currency,
        this.mapName,
        this.price,
        this.pricePlanCode,
        this.validity,
        this.volume});

  EconetBundleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bundle = json['bundle'];
    currency = json['currency'];
    mapName = json['mapName'];
    price = double.tryParse(json['price']) ?? 0.0;
    pricePlanCode = json['pricePlanCode'];
    validity = json['validity'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bundle'] = bundle;
    data['currency'] = currency;
    data['mapName'] = mapName;
    data['price'] = price;
    data['pricePlanCode'] = pricePlanCode;
    data['validity'] = validity;
    data['volume'] = volume;
    return data;
  }
}
