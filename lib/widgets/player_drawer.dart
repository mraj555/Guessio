import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlayerDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> user_data;

  const PlayerDrawer({super.key, required this.user_data});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: SizedBox(
          height: Get.height,
          child: ListView.builder(
            itemCount: user_data.length,
            itemBuilder: (context, index) {
              var data = user_data[index].values;
              return ListTile(
                title: Text(
                  data.elementAt(0),
                  style: TextStyle(color: Colors.black, fontSize: 23.sp),
                ),
                trailing: Text(
                  data.elementAt(1),
                  style: TextStyle(color: Colors.grey, fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
