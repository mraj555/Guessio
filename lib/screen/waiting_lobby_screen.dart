import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/paint_controller.dart';
import 'package:guessio/util/color_util.dart';

class WaitingLobbyScreen extends StatelessWidget {
  final int occupancy;
  final int no_of_players;

  const WaitingLobbyScreen({super.key, required this.occupancy, required this.no_of_players});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.03),
          Padding(
            padding: EdgeInsets.all(8).r,
            child: GetBuilder<PaintController>(
              builder: (_) {
                return Text('Waiting for ${occupancy - no_of_players} Players to Join', style: TextStyle(fontSize: 30.sp));
              },
            ),
          ),
          SizedBox(height: Get.height * 0.06),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<PaintController>(
              init: PaintController(),
              builder: (cnt) {
                return TextFormField(
                  readOnly: true,
                  onTap: cnt.onCopyRoomName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8).r,
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8).r,
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    filled: true,
                    fillColor: ColorUtil.whisper,
                    hintText: "Tap to copy room name",
                    hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Get.height * 0.1),
          Text("Players: ", style: TextStyle(fontSize: 18.sp)),
          GetBuilder<PaintController>(
            init: PaintController(),
            builder: (cnt) {
              return ListView.builder(
                itemCount: no_of_players,
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      "${index + 1}",
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      "${cnt.room_data['players'][index]['nickname']}",
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
