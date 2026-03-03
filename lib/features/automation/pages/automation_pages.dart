import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/automation/widget/automation_card.dart';
import 'package:smart_home_mobile/features/automation/widget/automation_tab.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  int selectedTab = 0;
  int selectedIndex = 1;

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
                    "Automation",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                AutomationTab(
                  selectedIndex: selectedTab,
                  onTap: (index) {
                    setState(() => selectedTab = index);
                  },
                ),

                SizedBox(height: 25.h),

                const AutomationCard(
                  title: "Lampu",
                  task: "2 task",
                  icon: Icons.lightbulb_outline,
                ),

                const AutomationCard(
                  title: "Television",
                  task: "2 task",
                  icon: Icons.tv,
                ),

                const AutomationCard(
                  title: "AC Kamar",
                  task: "2 task",
                  icon: Icons.ac_unit,
                ),

                const AutomationCard(
                  title: "AC Ruang Tamu",
                  task: "2 task",
                  icon: Icons.air,
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
