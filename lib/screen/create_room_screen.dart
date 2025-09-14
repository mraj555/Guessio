import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/create_room_controller.dart';
import 'package:guessio/util/color_util.dart';
import 'package:guessio/widgets/custom_text_field.dart';

class CreateRoomScreen extends StatelessWidget {
  CreateRoomScreen({super.key});

  final CreateRoomController controller = Get.put(CreateRoomController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Room",
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
            SizedBox(height: 15.h),
            GetBuilder<CreateRoomController>(
              builder: (_) {
                return DropdownButton<String>(
                  focusColor: ColorUtil.whisper,
                  items: controller.rounds
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: TextStyle(color: Colors.black)),
                        ),
                      )
                      .toList(),
                  value: controller.selected_round,
                  onChanged: controller.onChangeRound,
                  hint: Text(
                    "Select Max Rounds",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            GetBuilder<CreateRoomController>(
              builder: (_) {
                return DropdownButton<String>(
                  focusColor: ColorUtil.whisper,
                  items: controller.room_sizes
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: TextStyle(color: Colors.black)),
                        ),
                      )
                      .toList(),
                  value: controller.selected_room_size,
                  onChanged: controller.onChangeRoomSize,
                  hint: Text(
                    "Select Room Size",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: controller.onCreateRoom,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16.sp),
                minimumSize: Size(150.w, 35.h),
              ),
              child: Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
