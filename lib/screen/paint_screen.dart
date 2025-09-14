import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/paint_controller.dart';
import 'package:guessio/models/my_custom_painter.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<PaintController>(
        init: PaintController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
