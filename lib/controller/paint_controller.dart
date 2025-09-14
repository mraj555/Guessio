import 'dart:developer';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PaintController extends GetxController {
  late Socket socket;

  Map<dynamic, dynamic> data = {};

  String room_data = "";

  @override
  void onInit() {
    if (Get.arguments != null) data = Get.arguments;
    connect();
    super.onInit();
  }

  ///Socket IO Client Connection
  void connect() {
    socket = io('http://192.168.1.7:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    if (data["screenFrom"] == "createRoom") {
      data.remove("screenFrom");
      socket.emit('create-game', data);
    } else {
      data.remove("screenFrom");
      socket.emit('join-game', data);
    }

    ///Listen to Connect
    socket.onConnect((data) {
      socket.on('updateRoom', (value) {
        if (value is String) room_data = value;
        if (data['isJoin'] != true) {
          ///Start the timer
        }
      });
    });
    update();
  }
}
