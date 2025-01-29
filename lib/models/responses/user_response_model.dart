class UserModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  Company? company;
  List<CompanyProducts>? companyProducts;

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
      companyProducts = <CompanyProducts>[];
      json['company_products'].forEach((v) {
        companyProducts!.add(new CompanyProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.companyProducts != null) {
      data['company_products'] =
          this.companyProducts!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['company_registration_number'] = this.companyRegistrationNumber;
    data['email'] = this.email;
    data['telephone'] = this.telephone;
    data['external_reference'] = this.externalReference;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mobile'] = this.mobile;
    data['is_platform'] = this.isPlatform;
    data['integration_key'] = this.integrationKey;
    data['parent_company_id'] = this.parentCompanyId;
    return data;
  }
}

class CompanyProducts {
  int? id;
  String? displayName;

  CompanyProducts({this.id, this.displayName});

  CompanyProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    return data;
  }
}