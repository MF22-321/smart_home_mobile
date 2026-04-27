import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  bool isAutomatic = true;

  final List<Map<String, dynamic>> rules = [
    {
      "title": "Turn on lamp when dark",
      "subtitle": "Sunset → Sunrise",
      "icon": Icons.nightlight_round,
      "color": Color(0xffE8EEFF),
      "iconColor": Color(0xff4F7BFF),
      "value": true,
    },
    {
      "title": "Adjust AC when room > 26°C",
      "subtitle": "26°C → 24°C",
      "icon": Icons.thermostat,
      "color": Color(0xffE9F8EF),
      "iconColor": Color(0xff34C759),
      "value": true,
    },
    {
      "title": "Charge EV at off-peak hours",
      "subtitle": "11:00 PM → 6:00 AM",
      "icon": Icons.battery_charging_full,
      "color": Color(0xffF3E9FF),
      "iconColor": Color(0xff8B5CF6),
      "value": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                /// TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topButton(Icons.arrow_back_ios_new_rounded),
                    Text(
                      "FlexySave",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                          ).createShader(const Rect.fromLTWH(0, 0, 220, 80)),
                      ),
                    ),
                    _topButton(Icons.help_outline_rounded),
                  ],
                ),

                SizedBox(height: 28.h),

                /// TITLE
                Text(
                  "Mode Control",
                  style: TextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff0F172A),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Choose how your devices are managed.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),

                SizedBox(height: 24.h),

                /// TOGGLE MODE
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _modeButton(
                          title: "Automatic",
                          icon: Icons.smart_toy_outlined,
                          selected: isAutomatic,
                          onTap: () {
                            setState(() {
                              isAutomatic = true;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _modeButton(
                          title: "Manual",
                          icon: Icons.pan_tool_outlined,
                          selected: !isAutomatic,
                          onTap: () {
                            setState(() {
                              isAutomatic = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// MODE CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xffEEF8EE), Color(0xffDCEAFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Automatic Mode",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xff0F172A),
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffDCFCE7),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff22C55E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Active",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: const Color(0xff16A34A),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 18.h),

                                Text(
                                  "The system automatically controls your devices based on smart rules, schedules, and real-time conditions.",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 1.5,
                                    color: const Color(0xff475569),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Container(
                            width: 150.w,
                            height: 150.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                            child: Icon(
                              Icons.home_work_outlined,
                              size: 72.sp,
                              color: const Color(0xff3B82F6),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// FEATURES
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _feature(
                                Icons.eco_outlined,
                                "Energy Saving",
                                "Optimized usage",
                                const Color(0xff22C55E),
                              ),
                            ),
                            Expanded(
                              child: _feature(
                                Icons.shield_outlined,
                                "Smart Automation",
                                "Works for you",
                                const Color(0xff3B82F6),
                              ),
                            ),
                            Expanded(
                              child: _feature(
                                Icons.bar_chart,
                                "Real-time",
                                "Always optimizing",
                                const Color(0xff10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// HOW IT WORKS
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: const Color(0xff22C55E),
                        size: 22.sp,
                      ),
                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How it works",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "FlexySave analyzes data from your devices and sensors, then automatically adjusts power usage to save energy and reduce costs.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.6,
                                color: const Color(0xff64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 24.sp,
                        color: const Color(0xff64748B),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// RULES CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Automation Rules",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            "Manage",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff3B82F6),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward,
                            size: 18.sp,
                            color: const Color(0xff3B82F6),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      ...rules.map(
                        (item) => _ruleTile(
                          title: item["title"],
                          subtitle: item["subtitle"],
                          icon: item["icon"],
                          bg: item["color"],
                          iconColor: item["iconColor"],
                          value: item["value"],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topButton(IconData icon) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, size: 24.sp),
    );
  }

  Widget _modeButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                )
              : null,
          color: selected ? null : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: selected ? Colors.white : const Color(0xff2563EB),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xff111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xff64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ruleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bg,
    required Color iconColor,
    required bool value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xffEEF2F7)),
      ),
      child: Row(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28.sp),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: Colors.white,
            activeTrackColor: const Color(0xff22C55E),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xffD1D5DB),
          ),

          Icon(
            Icons.chevron_right,
            size: 22.sp,
            color: const Color(0xff9CA3AF),
          ),
        ],
      ),
    );
  }
}
