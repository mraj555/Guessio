import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guessio/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PaintController extends GetxController {
  late Socket socket;

  Map<dynamic, dynamic> data = {};

  Map<String, dynamic> room_data = {};

  List<TouchPoints> points = <TouchPoints>[];

  StrokeCap strokeType = StrokeCap.round;
  Color selected_color = Colors.black;

  double opacity = 1;
  double strokeWidth = 2;

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
        room_data = value;
        if (data['isJoin'] != true) {
          ///Start the timer
        }
        update();
      });

      socket.on('points', (point) {
        if (point['details'] != null) {
          points.add(
            TouchPoints(
              paint: Paint()
                ..strokeCap = strokeType
                ..isAntiAlias = true
                ..color = selected_color.withValues(alpha: opacity)
                ..strokeWidth = strokeWidth,
              points: Offset((point['details']['dx']).toDouble(), (point['details']['dy']).toDouble()),
            ),
          );
        }
        update();
      });
    });
    update();
  }

  ///Functionality for on Pan Start Button
  onPaintPanStart(DragStartDetails details) {
    socket.emit('paint', {
      'details': {'dx': details.localPosition.dx, 'dy': details.localPosition.dy},
      'roomName': data['name'],
    });
    update();
  }

  ///Functionality for on Pan Update Button
  onPaintPanUpdate(DragUpdateDetails details) {
    socket.emit('paint', {
      'details': {'dx': details.localPosition.dx, 'dy': details.localPosition.dy},
      'roomName': data['name'],
    });
    update();
  }

  ///Functionality for on Pan End Button
  onPaintPanEnd(DragEndDetails details) {
    socket.emit('paint', {'details': null, 'roomName': data['name']});
    update();
  }
}
