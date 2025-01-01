class ApiResponseModel {
  dynamic body;
  String? statusCode;
  String? statusText;

  ApiResponseModel({this.body, this.statusCode, this.statusText});

  ApiResponseModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    statusCode = json['statusCode'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['statusCode'] = this.statusCode;
    data['statusText'] = this.statusText;
    return data;
  }
}
