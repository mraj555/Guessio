import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
