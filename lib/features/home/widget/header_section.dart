import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/services/mqtt_service.dart';

class HeaderSection extends StatelessWidget {
  final MqttService mqttService;
  final bool mqttConnectionStatus;

  const HeaderSection({super.key, required this.mqttService, required this.mqttConnectionStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu, size: 28.sp),
              onPressed: () {
                // Open drawer or menu
                Scaffold.of(context).openDrawer();
              },
            ),
            Text(
              "FlexySave",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Stack(
              children: [
                Icon(Icons.notifications_none, size: 28.sp),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 25.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good morning, Arjun 👋",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Here's your energy overview",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: mqttConnectionStatus ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "LIVE",
                    style: TextStyle(
                      color: mqttConnectionStatus ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
