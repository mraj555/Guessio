import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guessio/controller/paint_controller.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<PaintController>(
        init: PaintController(),
        builder: (controller) {
          return Scaffold(
            body: Container(),
          );
        },
      ),
    );
  }
}
