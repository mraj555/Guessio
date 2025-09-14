import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guessio/screen/paint_screen.dart';

class CreateRoomController extends GetxController {
  TextEditingController name_controller = TextEditingController();
  TextEditingController room_controller = TextEditingController();

  List<String> rounds = ["2", "5", "10", "15"];
  List<String> room_sizes = ["2", "3", "4", "5", "6", "7", "8"];

  String? selected_round;
  String? selected_room_size;

  ///Functionality for Change Round
  onChangeRound(String? value) {
    selected_round = value;
    update();
  }

  ///Functionality for Change Room Size
  onChangeRoomSize(String? value) {
    selected_room_size = value;
    update();
  }

  ///Functionality for Create Room Button
  onCreateRoom() {
    if (name_controller.text.trim().isNotEmpty && room_controller.text.trim().isNotEmpty && selected_round != null && selected_room_size != null) {
      Map<String, dynamic> _data = {
        "nickname": name_controller.text.trim(),
        "name": room_controller.text.trim(),
        "occupancy": selected_round,
        "maxRounds": selected_room_size,
        "screenFrom": "createRoom",
      }
      ;
      Get.to(() => PaintScreen(), arguments: _data);
    }
    update();
  }
}
