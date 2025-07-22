import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

import '../screen/home/models/device_templete_data_model.dart';
import '../screen/login/screens/login_screen.dart';
import '../utils/constants/api_routes.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  RxString message = ''.obs;
  RxString type = ''.obs;
  RxBool isSocketConnected = false.obs;
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  Rxn<List<Carousal>> carousalList = Rxn<List<Carousal>>();
  Rxn<String> tempChange = Rxn<String>();
  var refreshKey = 0.obs;

  bool _isFirstConnect = true;

  @override
  void onInit() {
    super.onInit();
    // _initSocket();
  }

  void initSocket({Rxn<DeviceTempleteDataModel>? d}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwttoken = prefs.getString('jwt');
    final deviceId = prefs.getString('deviceId');
    socket = IO.io(
      ApiRoutes.socketURL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({"token": jwttoken})
          .setReconnectionDelay(2000)
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      log('Connected to Socket.IO Server', name: "server onConnect");
      isSocketConnected.value = true;
      onSocketConnectedOrReconnected();
      // Send the initial message after connecting
      String socketId = socket.id ?? "";
      sendMessage("broadcastMessage", {
        "device_id": deviceId,
        "socket_id": socketId,
      });
      Fluttertoast.showToast(
        msg: "Socket connected.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });

    socket.on('device_update', (response) {
      log('Connected to Socket.IO Server ${response}', name: "server on");
      _handleResponse(response, d);
    });

    socket.on('auth_error', (response) async {
      Fluttertoast.showToast(
        msg: "Connected to Socket.IO Server auth_error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      FirebaseCrashlytics.instance
          .log('Received type:- Connected to Socket.IO Server auth_error');
      log('Connected to Socket.IO Server auth_error', name: "server on");
      await prefs.clear();
      Get.offAll(() => LoginScreen());
    });

    socket.onDisconnect((_) {
      isSocketConnected.value = false;
      Fluttertoast.showToast(
        msg: "Socket not connected. Please check your internet connection.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      log('Socket Disconnected', name: "server disconnect");
    });
  }

// Assuming socketService uses a listener or status change event
  void onSocketConnectedOrReconnected() {
    if (_isFirstConnect) {
      _isFirstConnect = false;
    } else {
      refreshKey.value++; // Re-call API only on subsequent reconnects
    }
    // refreshKey.value++; // triggers the UI to rebuild homeFunction
  }

  void _handleResponse(dynamic response, Rxn<DeviceTempleteDataModel>? d) {
    try {
      Map<String, dynamic> jsonResponse = jsonDecode(jsonEncode(response));
      message.value = jsonResponse['message'];
      type.value = jsonResponse['type'];

      // Extract key-value pairs
      List<dynamic> dataList = jsonResponse['data'] ?? [];
      data.value = dataList
          .map((item) => {'key': item['key'], 'value': item['value']})
          .toList();

      switch (jsonResponse['type']) {
        case "opd_status":
          d!.value!.data!.informations!.opdStatus = dataList[0]["value"];
          d.refresh();
          break;

        case "template_update":
          d!.value!.data!.device!.templateId = dataList[0]["value"];
          tempChange.value = dataList[0]["value"];
          d.refresh();
          break;

        case "carousal_update":
          var carousalValue = dataList[0]["value"];

          if (carousalValue is List && carousalValue.isEmpty) {
            d!.value!.data!.carousal = [];
            carousalList.value = [];
          } else if (carousalValue is String) {
            d!.value!.data!.carousal = stringTocaraousalList(carousalValue);
            carousalList.value = stringTocaraousalList(carousalValue);
          } else {
            log('Unexpected data type for carousal_update: ${carousalValue.runtimeType}',
                name: "_handleResponse catch");
          }

          d!.refresh();
          break;

        default:
          // No action needed for unknown types
          break;
      }

      // log('Message==>: ${jsonResponse['type'] == "carousal_update" ? stringTocaraousalList(dataList[0]["value"]) : "Not Match"}',
      //     name: "_handleResponse msg");
      log('Message: ${message.value}', name: "_handleResponse msg");
      log('Type: ${type.value}', name: "_handleResponse Type");
      log('Data: $data', name: "_handleResponse Data");
    } catch (e, stackTrace) {
      log('Error parsing response: $e', name: "_handleResponse catch");
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Socket response parsing error');
    }
  }

  List<Carousal>? stringTocaraousalList(String urls) {
    List<Carousal> images = [];
    List<String> urlList = urls.split(", ");
    for (int i = 0; i < urlList.length; i++) {
      images.add(Carousal(
          sequence: (i + 1).toString(),
          fileType: (urlList[i].split('.').last == "jpg" ||
                  urlList[i].split('.').last == "jpeg")
              ? "image"
              : urlList[i].split('.').last == "mp4"
                  ? "video"
                  : urlList[i].split('.').last == "gif"
                      ? "gif"
                      : urlList[i].split('.').last,
          file: urlList[i],
          category: "carousel"));
    }

    log("message=>${urls} ${images}", name: "handleResponse Data");

    return images;
  }

  void sendMessage(String event, Map<String, dynamic> data) {
    socket.emit(event, data);
    log('Sent message: $event -> $data', name: "sendMessage");
  }

  void closeSocket() {
    if (socket.connected) {
      socket.disconnect();
      socket.dispose();
      isSocketConnected.value = false;
      log('Socket manually disconnected', name: "closeSocket");
    } else {
      log('Socket already disconnected', name: "closeSocket");
    }
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
