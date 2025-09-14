import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guessio/screen/home_screen.dart';
import 'package:guessio/screen/paint_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.73, 738.18),
      child: GetMaterialApp(
        title: 'Guessio',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
