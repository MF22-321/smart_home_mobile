import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

import '../widget/header_section.dart';
import '../widget/energy_summary_card.dart';
import '../widget/active_devices_card.dart';
import '../widget/usage_chart_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.only(
            top: 10.h,
            bottom: 120.h, // aman dari navbar
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              const HeaderSection(),

              SizedBox(height: 24.h),

              /// SUMMARY
              const EnergySummaryCard(),

              SizedBox(height: 24.h),

              /// ACTIVE DEVICES
              const ActiveDevicesCard(),

              SizedBox(height: 24.h),

              /// USAGE CHART
              const UsageChartCard(),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
