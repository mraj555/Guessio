import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/create_room_controller.dart';
import 'package:guessio/controller/join_room_controller.dart';
import 'package:guessio/util/color_util.dart';
import 'package:guessio/widgets/custom_text_field.dart';

class JoinRoomScreen extends StatelessWidget {
  JoinRoomScreen({super.key});

  final JoinRoomController controller = Get.put(JoinRoomController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Join Room",
              style: TextStyle(color: Colors.black, fontSize: 30.sp),
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomTextField(controller: controller.name_controller, hintText: "Enter Your Name"),
            ),
            SizedBox(height: 15.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomTextField(controller: controller.room_controller, hintText: "Enter Room Name"),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: controller.onJoinRoom,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16.sp),
                minimumSize: Size(150.w, 35.h),
              ),
              child: Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
