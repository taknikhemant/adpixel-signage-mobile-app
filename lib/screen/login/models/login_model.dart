class LoginModel {
  bool? status;
  String? message;
  String? accessToken;
  String? deviceId;
  String? templateId;
  String? tokenType;
  Data? data;

  LoginModel(
      {this.status,
      this.message,
      this.accessToken,
      this.deviceId,
      this.templateId,
      this.tokenType,
      this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['access_token'];
    deviceId = json['device_id'];
    templateId = json['template_id'];
    tokenType = json['token_type'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['access_token'] = accessToken;
    data['device_id'] = deviceId;
    data['template_id'] = templateId;
    data['token_type'] = tokenType;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? uuid;
  String? name;
  String? email;
  String? mobile;
  String? emailVerifiedAt;
  int? loginStatus;

  Data(
      {this.id,
      this.uuid,
      this.name,
      this.email,
      this.mobile,
      this.emailVerifiedAt,
      this.loginStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'].toString();
    loginStatus = json['login_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['email_verified_at'] = emailVerifiedAt;
    data['login_status'] = loginStatus;
    return data;
  }
}
