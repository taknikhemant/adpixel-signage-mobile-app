import 'dart:convert';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/home/models/device_templete_data_model.dart';
import '../screen/login/models/login_model.dart';
import '../screen/login/screens/login_screen.dart';
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

  Future logOut({Function? logOutFxn}) async {
    String url = ApiRoutes.baseURL + ApiRoutes.logout;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwttoken = prefs.getString('jwt');
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${jwttoken ?? ""}',
      },
    );

    log(url, name: "ApiServices--> logOut");
    log(response.statusCode.toString(), name: "ApiServices--> logOut");
    log(response.body.toString(), name: "ApiServices--> logOut");

    if (response.statusCode == 200) {
      await logOutFxn!();
      await prefs.clear();
      Get.offAll(() => LoginScreen());
      // await prefs.setString('fcmToken', model.data!.user!.deviceToken!);
      // log("${prefs.getString("jwt")}", name: "ApiServices--> login_JWT");
      return response.body;
    } else {
      return response.body;
    }
  }

  // Future<DeviceTempleteDataModel?> deviceTempData() async {
  //   String url = ApiRoutes.baseURL + ApiRoutes.deviceData;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final jwttoken = prefs.getString('jwt');
  //   final deviceId = prefs.getString('deviceId');
  //   final templeteId = prefs.getString('templateId');
  //   String btoken = jwttoken ?? "";
  //   Map<String, String> params = <String, String>{
  //     'device_id': deviceId!,
  //     'template_id': templeteId!,
  //   };
  //   final response = await client.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $btoken',
  //     },
  //     body: jsonEncode(params),
  //   );
  //   log(url, name: "ApiServices--> deviceTempData");
  //   log(jsonEncode(params), name: "ApiServices--> deviceTempData");
  //   log("${response.statusCode}", name: "ApiServices--> deviceTempData");
  //   log(response.body.toString(), name: "ApiServices--> deviceTempData");
  //   DeviceTempleteDataModel model =
  //       DeviceTempleteDataModel.fromJson(jsonDecode(response.body));
  //   if (response.statusCode == 200) {
  //     return model;
  //   } else if (response.statusCode == 401 || response.statusCode == 422) {
  //     await prefs.clear();
  //     Get.offAll(() => LoginScreen());
  //     return null;
  //   } else {
  //     return model;
  //   }
  // }

  Future<DeviceTempleteDataModel?> deviceTempData() async {
    String url = ApiRoutes.baseURL + ApiRoutes.deviceData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwttoken = prefs.getString('jwt');
    final deviceId = prefs.getString('deviceId');
    final templeteId = prefs.getString('templateId');
    String btoken = jwttoken ?? "";

    Map<String, String> params = {
      'device_id': deviceId!,
      'template_id': templeteId!,
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
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

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Save JSON to cache
        prefs.setString('cached_device_temp_data', jsonEncode(jsonData));

        return DeviceTempleteDataModel.fromJson(jsonData);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        await prefs.clear();
        Get.offAll(() => LoginScreen());
        if (response.statusCode == 422) {
          FirebaseCrashlytics.instance
              .log('Received type:- Connected to Socket.IO Server auth_error');
        }
        return null;
      } else {
        // Even on failure, try parsing response
        return DeviceTempleteDataModel.fromJson(jsonData);
      }
    } catch (e) {
      log(e.toString(), name: "ApiServices--> Exception");

      // 📴 Offline or network error, try cached data
      final cached = prefs.getString('cached_device_temp_data');
      if (cached != null) {
        try {
          final cachedJson = jsonDecode(cached);
          return DeviceTempleteDataModel.fromJson(cachedJson);
        } catch (e) {
          log("Error decoding cached data: $e", name: "OfflineMode");
          return null;
        }
      }

      // 🟥 No cached data available
      return null;
    }
  }
}
