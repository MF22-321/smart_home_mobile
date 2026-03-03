import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/features/home/widget/carousel_card.dart';
import 'package:smart_home_mobile/features/home/widget/device_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool smartLight = true;
  bool solarPanel = false;
  bool doorLocks = false;
  bool tv = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// SCROLLABLE CONTENT
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 120.h), // space for navbar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      Center(
                        child: Text(
                          "My Home",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.title,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      const ControllerCard(),

                      SizedBox(height: 25.h),

                      Text(
                        "Devices",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.title,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      DeviceTile(
                        title: "Smart lights",
                        subtitle: "Living room · 4 devices",
                        value: smartLight,
                        onChanged: (val) => setState(() => smartLight = val),
                      ),

                      DeviceTile(
                        title: "Solar panel",
                        subtitle: "Capacity · 78%",
                        value: solarPanel,
                        onChanged: (val) => setState(() => solarPanel = val),
                      ),

                      DeviceTile(
                        title: "Door locks",
                        subtitle: "Capacity · 3 devices",
                        value: doorLocks,
                        onChanged: (val) => setState(() => doorLocks = val),
                      ),

                      DeviceTile(
                        title: "Television",
                        subtitle: "Capacity · 4 devices",
                        value: tv,
                        onChanged: (val) => setState(() => tv = val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
