import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FinalLeaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> scoreboard;
  final String winner;

  const FinalLeaderboard(this.scoreboard, this.winner);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8).r,
        height: Get.height,
        child: Column(
          children: [
            ListView.builder(
              itemCount: scoreboard.length,
              primary: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = scoreboard[index].values;
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
            Padding(
              padding: const EdgeInsets.all(10.0).r,
              child: Text(
                "$winner has won the game!",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
