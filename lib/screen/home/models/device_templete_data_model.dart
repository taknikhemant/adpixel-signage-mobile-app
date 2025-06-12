class DeviceTempleteDataModel {
  bool? status;
  String? message;
  Data? data;

  DeviceTempleteDataModel({this.status, this.message, this.data});

  DeviceTempleteDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == true;
    message = _getString(json, 'message');
    data = json.containsKey('data') &&
            json['data'] is Map &&
            json['data'].isNotEmpty
        ? Data.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  Device? device;
  Informations? informations;
  List<Carousal>? carousal;

  Data({this.device, this.informations, this.carousal});

  Data.fromJson(Map<String, dynamic> json) {
    device = json.containsKey('device') && json['device'] is Map
        ? Device.fromJson(json['device'])
        : null;
    informations =
        json.containsKey('informations') && json['informations'] is Map
            ? Informations.fromJson(json['informations'])
            : null;

    // if (json.containsKey('carousal') && json['carousal'] is List) {
    //   carousal = [];
    //   for (var v in json['carousal']) {
    //     if (v is Map && v.isNotEmpty) {
    //       carousal!.add(Carousal.fromJson(v));
    //     }
    //   }
    // }
    if (json.containsKey('carousal') && json['carousal'] is List) {
      carousal = [];
      for (var v in json['carousal']) {
        if (v is Map) {
          carousal!.add(Carousal.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'device': device?.toJson(),
        'informations': informations?.toJson(),
        'carousal': carousal?.map((e) => e.toJson()).toList(),
      };
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
  // String? opdStatus;
  DeviceAppearance? deviceAppearance;

  Device({
    this.id,
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
    // this.opdStatus,
    this.deviceAppearance,
  });

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = _getString(json, 'uuid');
    customerId = _getString(json, 'customer_id');
    size = _getString(json, 'size');
    orientation = _getString(json, 'orientation');
    brand = _getString(json, 'brand');
    templateId = _getString(json, 'template_id');
    status = json['status'];
    createdAt = _getString(json, 'created_at');
    updatedAt = _getString(json, 'updated_at');
    loginStatus = _getString(json, 'login_status');
    // opdStatus = _getString(json, 'opd_status');
    deviceAppearance = json.containsKey('device_appearance') &&
            json['device_appearance'] is Map
        ? DeviceAppearance.fromJson(json['device_appearance'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'customer_id': customerId,
        'size': size,
        'orientation': orientation,
        'brand': brand,
        'template_id': templateId,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'login_status': loginStatus,
        // 'opd_status': opdStatus,
        'device_appearance': deviceAppearance?.toJson(),
      };
}

class DeviceAppearance {
  String? textColor;
  String? iconColor;
  String? primaryBgColor;
  String? secondaryBgColor;

  DeviceAppearance({
    this.textColor,
    this.iconColor,
    this.primaryBgColor,
    this.secondaryBgColor,
  });

  DeviceAppearance.fromJson(Map<String, dynamic> json) {
    textColor = _getString(json, 'text_color');
    iconColor = _getString(json, 'icon_color');
    primaryBgColor = _getString(json, 'primary_bg_color');
    secondaryBgColor = _getString(json, 'secondary_bg_color');
  }

  Map<String, dynamic> toJson() => {
        'text_color': textColor,
        'icon_color': iconColor,
        'primary_bg_color': primaryBgColor,
        'secondary_bg_color': secondaryBgColor,
      };
}

class Informations {
  String? docName;
  String? docSpecialist;
  String? docOtherSpecialization;
  String? docAvtar;
  String? docOpdDays;
  String? docOpdTime;
  String? opdStatus;
  String? backGroundImage;

  Informations({
    this.docName,
    this.docSpecialist,
    this.docOtherSpecialization,
    this.docAvtar,
    this.docOpdDays,
    this.docOpdTime,
    this.opdStatus,
    this.backGroundImage,
  });

  Informations.fromJson(Map<String, dynamic> json) {
    docName = _getString(json, 'doc_name');
    docSpecialist = _getString(json, 'doc_specialist');
    docOtherSpecialization = _getString(json, 'doc_other_specialization');
    docAvtar = _getString(json, 'doc_avtar');
    docOpdDays = _getString(json, 'doc_opd_days');
    docOpdTime = _getString(json, 'doc_opd_time');
    opdStatus = _getString(json, 'opd_status');
    backGroundImage = _getString(json, 'back_ground_image');
  }

  Map<String, dynamic> toJson() => {
        'doc_name': docName,
        'doc_specialist': docSpecialist,
        'doc_other_specialization': docOtherSpecialization,
        'doc_avtar': docAvtar,
        'doc_opd_days': docOpdDays,
        'doc_opd_time': docOpdTime,
        'opd_status': opdStatus,
      };
}

class Carousal {
  String? sequence;
  String? fileType;
  String? file;
  String? localFile;
  String? category;
  List<DynamicFieldValue>? dynamicFieldsValue;

  Carousal({
    this.sequence,
    this.fileType,
    this.file,
    this.localFile,
    this.category,
    this.dynamicFieldsValue,
  });

  Carousal.fromJson(Map<String, dynamic> json) {
    sequence = _getString(json, 'sequence');
    fileType = _getString(json, 'file_type');
    file = _getString(json, 'file');
    localFile = _getString(json, 'local_file');
    category = _getString(json, 'category');
    if (json['dynamic_fields_value'] is List) {
      dynamicFieldsValue = (json['dynamic_fields_value'] as List)
          .map((e) => DynamicFieldValue.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'sequence': sequence,
        'file_type': fileType,
        'file': file,
        'local_file': localFile,
        'category': category,
        'dynamic_fields_value':
            dynamicFieldsValue?.map((e) => e.toJson()).toList(),
      };
}

class DynamicFieldValue {
  String? key;
  String? value;

  DynamicFieldValue({this.key, this.value});

  DynamicFieldValue.fromJson(Map<String, dynamic> json) {
    key = _getString(json, 'key');
    value = _getString(json, 'value');
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}

String? _getString(Map<String, dynamic> json, String key) {
  return json.containsKey(key) &&
          json[key] is String &&
          json[key].toString().trim().isNotEmpty
      ? json[key].toString()
      : null;
}
