import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guessio/screen/paint_screen.dart';

class JoinRoomController extends GetxController {
  TextEditingController name_controller = TextEditingController();
  TextEditingController room_controller = TextEditingController();

  ///Functionality For Join Room Button
  onJoinRoom() {
    if (name_controller.text.trim().isNotEmpty && room_controller.text.trim().isNotEmpty) {
      Map<String, dynamic> data = {"nickname": name_controller.text.trim(), "name": room_controller.text.trim(), "screenFrom": "joinRoom"};
      Get.to(() => PaintScreen(), arguments: data);
    }
    update();
  }
}
