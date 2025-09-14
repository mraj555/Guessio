import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/screen/create_room_screen.dart';
import 'package:guessio/screen/join_room_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create/Join a room to play!",
              style: TextStyle(color: Colors.black, fontSize: 24.sp),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Get.to(() => CreateRoomScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 16.sp),
                    minimumSize: Size(150.w, 35.h),
                  ),
                  child: Text("Create"),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(() => JoinRoomScreen()),
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
          ],
        ),
      ),
    );
  }
}
