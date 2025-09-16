import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/paint_controller.dart';
import 'package:guessio/models/my_custom_painter.dart';
import 'package:guessio/screen/final_leaderboard.dart';
import 'package:guessio/screen/waiting_lobby_screen.dart';
import 'package:guessio/util/color_util.dart';
import 'package:guessio/widgets/player_drawer.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<PaintController>(
        init: PaintController(),
        builder: (controller) {
          return Scaffold(
            key: controller.scaffold_key,
            drawer: PlayerDrawer(user_data: controller.scoreboard),
            backgroundColor: Colors.white,
            body: controller.room_data != null
                ? controller.room_data['isJoin'] != true
                      ? !controller.isShowFinalLeaderboard
                            ? Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width,
                                        height: Get.height * 0.55,
                                        child: GestureDetector(
                                          onPanUpdate: controller.onPaintPanUpdate,
                                          onPanStart: controller.onPaintPanStart,
                                          onPanEnd: controller.onPaintPanEnd,
                                          child: SizedBox.expand(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20).r,
                                              child: RepaintBoundary(
                                                child: CustomPaint(
                                                  size: Size.infinite,
                                                  painter: MyCustomPainter(pointsList: controller.points),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GetBuilder<PaintController>(
                                        builder: (_) {
                                          return Row(
                                            children: [
                                              IconButton(
                                                onPressed: controller.onChangeColor,
                                                icon: Icon(Icons.color_lens),
                                                style: IconButton.styleFrom(foregroundColor: controller.selected_color),
                                              ),
                                              Expanded(
                                                child: Slider(
                                                  value: controller.strokeWidth,
                                                  onChanged: controller.onChangedStrokeWidth,
                                                  min: 1.0,
                                                  max: 10,
                                                  label: "Strokewidth ${controller.strokeWidth}",
                                                  activeColor: controller.selected_color,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: controller.onClearCanvas,
                                                icon: Icon(Icons.layers_clear),
                                                style: IconButton.styleFrom(foregroundColor: controller.selected_color),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                      GetBuilder<PaintController>(
                                        builder: (_) {
                                          return controller.room_data['turn']['nickname'] != controller.data['nickname']
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: controller.text_blank_widget,
                                                )
                                              : Center(
                                                  child: Text("${controller.room_data['word']}", style: TextStyle(fontSize: 30.sp)),
                                                );
                                        },
                                      ),

                                      GetBuilder<PaintController>(
                                        builder: (_) {
                                          return SizedBox(
                                            height: Get.height * 0.3,
                                            child: ListView.builder(
                                              controller: controller.scroll_controller,
                                              itemCount: controller.messages.length,
                                              itemBuilder: (context, index) {
                                                var msg = controller.messages[index].values;
                                                return ListTile(
                                                  title: Text(
                                                    msg.elementAt(0),
                                                    style: TextStyle(color: Colors.black, fontSize: 19.sp, fontWeight: FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    msg.elementAt(1),
                                                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  GetBuilder<PaintController>(
                                    builder: (_) => controller.room_data['turn']['nickname'] != controller.data['nickname']
                                        ? Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 20).r,
                                              child: TextFormField(
                                                controller: controller.guess_controller,
                                                autocorrect: false,

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
                                                  hintText: 'Your Guess',
                                                  hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                                                ),
                                                textInputAction: TextInputAction.done,
                                                readOnly: controller.isTextInputReadOnly,
                                                onFieldSubmitted: controller.onSubmitGuess,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                  SafeArea(
                                    child: IconButton(
                                      onPressed: controller.onMenu,
                                      icon: Icon(Icons.menu),
                                      style: IconButton.styleFrom(foregroundColor: Colors.black),
                                    ),
                                  ),
                                ],
                              )
                            : FinalLeaderboard(controller.scoreboard, controller.winner)
                      : WaitingLobbyScreen(
                          no_of_players: controller.room_data['players'].length,
                          occupancy: controller.room_data['occupancy'],
                        )
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 30.h),
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 7,
                backgroundColor: Colors.white,
                child: GetBuilder<PaintController>(
                  builder: (_) {
                    return Text(
                      "${controller.start}",
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
