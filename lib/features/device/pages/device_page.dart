import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/device/widget/device_card.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  int selectedIndex = 0;

  final List<String> houses = [
    "Rumah Festivale",
    "Rumah Perumnas",
    "Rumah Cibitung",
    "Rumah Jakarta",
    "Rumah Karawang",
    "Rumah Bekasi",
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                Center(
                  child: Text(
                    "Scan Device",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                Text(
                  "Scanning.....",
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),

                SizedBox(height: 15.h),

                /// DEVICE LIST
                ...List.generate(
                  houses.length,
                  (index) => DeviceCard(
                    title: houses[index],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
