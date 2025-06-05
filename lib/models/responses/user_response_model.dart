class UserModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  Company? company;
  List<CompanyProduct>? companyProducts;

  UserModel(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.company,
      this.companyProducts});

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    if (json['company_products'] != null) {
      companyProducts = <CompanyProduct>[];
      json['company_products'].forEach((v) {
        companyProducts!.add(new CompanyProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (companyProducts != null) {
      data['company_products'] =
          companyProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  int? id;
  String? companyName;
  String? companyRegistrationNumber;
  String? email;
  String? telephone;
  String? externalReference;
  String? type;
  String? createdAt;
  String? updatedAt;
  Null? mobile;
  int? isPlatform;
  String? integrationKey;
  Null? parentCompanyId;

  Company(
      {this.id,
      this.companyName,
      this.companyRegistrationNumber,
      this.email,
      this.telephone,
      this.externalReference,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.mobile,
      this.isPlatform,
      this.integrationKey,
      this.parentCompanyId});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyRegistrationNumber = json['company_registration_number'];
    email = json['email'];
    telephone = json['telephone'];
    externalReference = json['external_reference'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mobile = json['mobile'];
    isPlatform = json['is_platform'];
    integrationKey = json['integration_key'];
    parentCompanyId = json['parent_company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['company_registration_number'] = companyRegistrationNumber;
    data['email'] = email;
    data['telephone'] = telephone;
    data['external_reference'] = externalReference;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['mobile'] = mobile;
    data['is_platform'] = isPlatform;
    data['integration_key'] = integrationKey;
    data['parent_company_id'] = parentCompanyId;
    return data;
  }
}

class CompanyProduct {
  int? id;
  String? displayName;
  String? currency;

  CompanyProduct({this.id, this.displayName, this.currency});

  CompanyProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_name'] = displayName;
    data['currency'] = currency;
    return data;
  }
}