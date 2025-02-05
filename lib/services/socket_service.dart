import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

import '../screen/home/models/device_templete_data_model.dart';
import '../screen/login/screens/login_screen.dart';
import '../utils/constants/api_routes.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  RxString message = ''.obs;
  RxString type = ''.obs;
  RxBool isSocketConnected = false.obs;
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  // final String deviceId = "7fa24bd5-3060-42bc-9555-a147a2ea0da5"; // Replace with actual device ID

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
      // Send the initial message after connecting
      String socketId = socket.id ?? "";
      sendMessage("broadcastMessage", {
        "device_id": deviceId,
        "socket_id": socketId,
      });
    });

    socket.on('device_update', (response) {
      log('Connected to Socket.IO Server', name: "server on");
      _handleResponse(response, d);
    });

    socket.on('auth_error', (response) async {
      log('Connected to Socket.IO Server auth_error', name: "server on");
      await prefs.clear();
      Get.offAll(() => LoginScreen());
    });

    socket.onDisconnect((_) {
      isSocketConnected.value = false;
      log('Socket Disconnected', name: "server disconnect");
    });
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
          d!.value!.data!.device!.opdStatus = dataList[0]["value"];
          d.refresh();
          break;

        case "template_update":
          d!.value!.data!.device!.templateId = dataList[0]["value"];
          d.refresh();
          break;

        case "carousal_update":
          d!.value!.data!.carousal = [];
          d.value!.data!.carousal = stringTocaraousalList(dataList[0]["value"]);
          d.refresh();
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
    } catch (e) {
      log('Error parsing response: $e', name: "_handleResponse catch");
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
      ));
    }

    log("message=>${urls} ${images}", name: "handleResponse Data");

    return images;
  }

  void sendMessage(String event, Map<String, dynamic> data) {
    socket.emit(event, data);
    log('Sent message: $event -> $data', name: "sendMessage");
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
