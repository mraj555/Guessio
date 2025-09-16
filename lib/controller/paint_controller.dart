import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/models/touch_points.dart';
import 'package:guessio/screen/home_screen.dart';
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

  List<Widget> text_blank_widget = <Widget>[];

  ScrollController scroll_controller = ScrollController();

  List<Map<String, dynamic>> messages = [];

  TextEditingController guess_controller = TextEditingController();

  int user_counter = 0;

  int start = 60;

  late Timer timer;

  GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> scoreboard = [];
  bool isTextInputReadOnly = false;
  int max_points = 0;
  String winner = "";
  bool isShowFinalLeaderboard = false;

  @override
  void onInit() {
    if (Get.arguments != null) data = Get.arguments;
    connect();
    super.onInit();
  }

  ///Functionality for start timer
  void onStartTimer() {
    const one_sec = Duration(seconds: 1);
    timer = Timer.periodic(one_sec, (timer) {
      if (start == 0) {
        socket.emit('change-turn', room_data['name']);
        timer.cancel();
      } else {
        start--;
      }
    });
    update();
  }

  void onRenderTextBlank(String text) {
    text_blank_widget.clear();
    for (int i = 0; i < text.length; i++) {
      text_blank_widget.add(Text("_", style: TextStyle(fontSize: 30.sp)));
    }
    update();
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
        onRenderTextBlank(value['word']);
        room_data = value;
        if (value['isJoin'] != true) {
          onStartTimer();
        }
        scoreboard.clear();
        for (int i = 0; i < value['players'].length; i++) {
          scoreboard.add({'username': value['players'][i]['nickname'], 'points': value['players'][i]['points'].toString()});
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

      socket.on('update-score', (room) {
        scoreboard.clear();
        for (int i = 0; i < room['players'].length; i++) {
          scoreboard.add({'username': room['players'][i]['nickname'], 'points': room['players'][i]['points'].toString()});
        }
        update();
      });

      socket.on('show-leaderboard', (players) {
        scoreboard.clear();
        for (int i = 0; i < players.length; i++) {
          scoreboard.add({'username': players[i]['nickname'], 'points': players[i]['points'].toString()});
          if (max_points < int.parse(scoreboard[i]['points'])) {
            winner = scoreboard[i]['username'];
            max_points = int.parse(scoreboard[i]['points']);
          }
        }
        timer.cancel();
        isShowFinalLeaderboard = true;
        update();
      });

      socket.on('color-change', (colorString) {
        int value = int.parse(colorString, radix: 16);
        Color other_color = Color(value);
        log("$colorString:$value", name: "Color String");
        selected_color = other_color;
        update();
      });

      socket.on('stroke-width', (stroke) {
        strokeWidth = stroke;
        update();
      });

      socket.on('clear-canvas', (data) {
        points.clear();
        update();
      });

      socket.on('closeInput', (_) {
        socket.emit('update-score', data['name']);
        isTextInputReadOnly = true;
        update();
      });

      socket.on('msg', (data) {
        messages.add(data);
        user_counter = data['user_counter'];
        if (user_counter == room_data['players'].length - 1) {
          socket.emit('change-turn', room_data['name']);
        }
        scroll_controller.animateTo(
          scroll_controller.position.maxScrollExtent + 40,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        update();
      });

      socket.on('change-turn', (data) {
        String old_word = room_data['word'];
        Get.dialog(AlertDialog(title: Center(child: Text("Word was $old_word"))));
        Future.delayed(Duration(seconds: 3), () {
          room_data = data;
          onRenderTextBlank(room_data['word']);
          user_counter = 0;
          start = 60;
          points.clear();
          isTextInputReadOnly = false;
          Get.back();
          timer.cancel();
          onStartTimer();
        });
        update();
      });

      socket.on('user-disconnected', (room) {
        scoreboard.clear();
        for (int i = 0; i < room['players'].length; i++) {
          scoreboard.add({'username': room['players'][i]['nickname'], 'points': room['players'][i]['points'].toString()});
        }
        update();
      });

      socket.on('notCorrectGame', (data) {
        Get.offAll(() => HomeScreen());
      });
    });
    update();
  }

  @override
  onClose() {
    socket.dispose();
    timer.cancel();
    super.onClose();
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

  ///Functionality For Change Color
  onChangeColor() {
    Get.dialog(
      AlertDialog(
        title: Text("Choose Color"),
        content: SingleChildScrollView(
          child: GetBuilder<PaintController>(
            init: this,
            builder: (context) {
              return BlockPicker(
                pickerColor: selected_color,
                onColorChanged: (color) {
                  String color_string = color.toHexString();
                  Map<String, dynamic> map = {'color': color_string, 'roomName': data['name']};
                  socket.emit('color-change', map);
                  update();
                },
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('Close'))],
      ),
    );
    update();
  }

  ///Functionality For Increase/Decrease Stroke Width
  onChangedStrokeWidth(double value) {
    Map<String, dynamic> map = {'value': value, 'roomName': data['name']};
    socket.emit('stroke-width', map);
    update();
  }

  ///Functionality for Clear Canvas
  onClearCanvas() {
    socket.emit('clear-canvas', data['name']);
    update();
  }

  ///Functionality for Submit Guess Word
  onSubmitGuess(String value) {
    if (value.trim().isNotEmpty) {
      Map<String, dynamic> map = {
        'username': data['nickname'],
        'msg': value.trim(),
        'word': room_data['word'],
        'roomName': data['name'],
        'user_counter': user_counter,
        'totalTime': 60,
        'timeTaken': 60 - start,
      };
      socket.emit('msg', map);
      guess_controller.clear();
    }
    update();
  }

  ///Functionality for Copy Room Name
  onCopyRoomName() {
    Clipboard.setData(ClipboardData(text: room_data['name']));
    Get.showSnackbar(GetSnackBar(message: "Copied"));
    update();
  }

  ///Functionality for Drawer
  onMenu() {
    scaffold_key.currentState!.openDrawer();
    update();
  }
}
