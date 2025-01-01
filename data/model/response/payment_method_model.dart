class PaymentMethodModel {
  String? getway;
  String? logo;
  String? name;
  int? status;
  String? accountMessage;
  int? API;
  String? API_URL;
  String? VERIFY_CODE_URL;

  PaymentMethodModel({this.getway, this.logo, this.name, this.status, this.accountMessage, this.API, this.API_URL, this.VERIFY_CODE_URL});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    // print("paymmmmm: ${json}");
    getway = json['getway'];
    logo = json['logo'];
    name = json['name'];
    status = int.parse(json['status']);
    // status = json['status'];
    accountMessage = json['account_message'];
    API = json['api'];
    API_URL = json['f_api'];
    VERIFY_CODE_URL = json['s_api'];
    //  print("paymmmmm2: ${json}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['getway'] = this.getway;
    data['image'] = this.logo;
    data['name'] = this.name;
    data['status'] = this.status;
    data['account_message'] = this.accountMessage;
    data['api'] = this.API;
    data['f_api'] = this.API_URL;
    data['s_api'] = this.VERIFY_CODE_URL;
    return data;
  }
}
