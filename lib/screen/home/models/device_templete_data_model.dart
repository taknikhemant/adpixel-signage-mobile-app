class DeviceTempleteDataModel {
  bool? status;
  String? message;
  Data? data;

  DeviceTempleteDataModel({this.status, this.message, this.data});

  DeviceTempleteDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Device? device;
  Informations? informations;
  List<Carousal>? carousal;

  Data({this.device, this.informations, this.carousal});

  Data.fromJson(Map<String, dynamic> json) {
    device = json['device'] != null ? Device.fromJson(json['device']) : null;
    informations = json['informations'] != null
        ? Informations.fromJson(json['informations'])
        : null;
    if (json['carousal'] != null) {
      carousal = <Carousal>[];
      json['carousal'].forEach((v) {
        carousal!.add(Carousal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (device != null) {
      data['device'] = device!.toJson();
    }
    if (informations != null) {
      data['informations'] = informations!.toJson();
    }
    if (carousal != null) {
      data['carousal'] = carousal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Device {
  int? id;
  String? uuid;
  String? customerId;
  String? size;
  String? orientation;
  String? brand;
  String? templateId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? loginStatus;
  String? opdStatus;
  DeviceAppearance? deviceAppearance;

  Device(
      {this.id,
      this.uuid,
      this.customerId,
      this.size,
      this.orientation,
      this.brand,
      this.templateId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.loginStatus,
      this.opdStatus,
      this.deviceAppearance});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    customerId = json['customer_id'];
    size = json['size'];
    orientation = json['orientation'];
    brand = json['brand'];
    templateId = json['template_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loginStatus = json['login_status'];
    opdStatus = json['opd_status'];
    deviceAppearance = json['device_appearance'] != null
        ? DeviceAppearance.fromJson(json['device_appearance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['customer_id'] = customerId;
    data['size'] = size;
    data['orientation'] = orientation;
    data['brand'] = brand;
    data['template_id'] = templateId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['login_status'] = loginStatus;
    data['opd_status'] = opdStatus;
    if (deviceAppearance != null) {
      data['device_appearance'] = deviceAppearance!.toJson();
    }
    return data;
  }
}

class DeviceAppearance {
  String? textColor;
  String? iconColor;
  String? primaryBgColor;
  String? secondaryBgColor;

  DeviceAppearance(
      {this.textColor,
      this.iconColor,
      this.primaryBgColor,
      this.secondaryBgColor});

  DeviceAppearance.fromJson(Map<String, dynamic> json) {
    textColor = json['text_color'];
    iconColor = json['icon_color'];
    primaryBgColor = json['primary_bg_color'];
    secondaryBgColor = json['secondary_bg_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text_color'] = textColor;
    data['icon_color'] = iconColor;
    data['primary_bg_color'] = primaryBgColor;
    data['secondary_bg_color'] = secondaryBgColor;
    return data;
  }
}

class Informations {
  String? docName;
  String? docSpecialist;
  String? docOtherSpecialization;
  String? docAvtar;
  String? docOpdDays;
  String? docOpdTime;

  Informations(
      {this.docName,
      this.docSpecialist,
      this.docOtherSpecialization,
      this.docAvtar,
      this.docOpdDays,
      this.docOpdTime});

  Informations.fromJson(Map<String, dynamic> json) {
    docName = json['doc_name'];
    docSpecialist = json['doc_specialist'];
    docOtherSpecialization = json['doc_other_specialization'];
    docAvtar = json['doc_avtar'];
    docOpdDays = json['doc_opd_days'];
    docOpdTime = json['doc_opd_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doc_name'] = docName;
    data['doc_specialist'] = docSpecialist;
    data['doc_other_specialization'] = docOtherSpecialization;
    data['doc_avtar'] = docAvtar;
    data['doc_opd_days'] = docOpdDays;
    data['doc_opd_time'] = docOpdTime;
    return data;
  }
}

class Carousal {
  String? sequence;
  String? fileType;
  String? file;

  Carousal({this.sequence, this.fileType, this.file});

  Carousal.fromJson(Map<String, dynamic> json) {
    sequence = json['sequence'];
    fileType = json['file_type'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sequence'] = sequence;
    data['file_type'] = fileType;
    data['file'] = file;
    return data;
  }
}
