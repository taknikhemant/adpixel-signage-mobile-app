import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/home/models/device_templete_data_model.dart';
import '../screen/login/models/login_model.dart';
import '../utils/constants/api_routes.dart';

class ApiServices {
  ApiServices._privateConstructor();
  static final ApiServices instance = ApiServices._privateConstructor();
  var client = http.Client();

  Future<LoginModel?> login({required String password}) async {
    String url = ApiRoutes.baseURL + ApiRoutes.login;
    Map<String, String> params = <String, String>{
      'pass_pixel': password,
    };
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(params),
    );

    log(url, name: "ApiServices--> login");
    log(jsonEncode(params), name: "ApiServices--> login");
    log(response.body.toString(), name: "ApiServices--> login");
    LoginModel model = LoginModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', model.accessToken!);
      await prefs.setString('deviceId', model.deviceId!);
      await prefs.setString('templateId', model.templateId!);
      await prefs.setString('uuid', model.data!.uuid!);
      // await prefs.setString('fcmToken', model.data!.user!.deviceToken!);
      // log("${prefs.getString("jwt")}", name: "ApiServices--> login_JWT");
      return model;
    } else {
      return model;
    }
  }

  Future<DeviceTempleteDataModel?> deviceTempData() async {
    String url = ApiRoutes.baseURL + ApiRoutes.deviceData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwttoken = prefs.getString('jwt');
    final deviceId = prefs.getString('deviceId');
    final templeteId = prefs.getString('templateId');
    String btoken = jwttoken ?? "";
    Map<String, String> params = <String, String>{
      'device_id': deviceId!,
      'template_id': templeteId!,
    };
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $btoken',
      },
      body: jsonEncode(params),
    );
    log(url, name: "ApiServices--> deviceTempData");
    log(jsonEncode(params), name: "ApiServices--> deviceTempData");
    log("${response.statusCode}", name: "ApiServices--> deviceTempData");
    log(response.body.toString(), name: "ApiServices--> deviceTempData");
    DeviceTempleteDataModel model =
        DeviceTempleteDataModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return model;
    } else if (response.statusCode == 401 || response.statusCode == 422) {
      await prefs.clear();
      return null;
    } else {
      return model;
    }
  }
}
