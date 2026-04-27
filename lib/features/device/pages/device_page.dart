import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<DevicePage> {
  int selectedCategory = 0;

  final List<Map<String, dynamic>> devices = [
    {
      "name": "Lamp",
      "status": true,
      "power": "12 W",
      "icon": Icons.lightbulb_outline,
    },
    {
      "name": "Socket",
      "status": true,
      "power": "230 W",
      "icon": Icons.power_outlined,
    },
    {"name": "Fan", "status": false, "power": "0 W", "icon": Icons.air},
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

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topIcon(Icons.menu),
                    Text(
                      "FlexySave",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    Stack(
                      children: [
                        _topIcon(Icons.notifications_none),
                        Positioned(
                          right: 6.w,
                          top: 6.h,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Color(0xff22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                /// TITLE
                Text(
                  "Device Control",
                  style: TextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff111827),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Manage and monitor your smart devices",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),

                SizedBox(height: 24.h),

                /// POWER CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xffEEF8EE), Color(0xffCFE5FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bolt,
                          size: 36.sp,
                          color: const Color(0xff22C55E),
                        ),
                      ),

                      SizedBox(width: 18.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Power Usage",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xff374151),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Text(
                                  "342",
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xff111827),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text(
                                    "W",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      color: const Color(0xff374151),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
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
                                  "Live • Updated just now",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xff4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                /// CATEGORY
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip("All Devices", Icons.grid_view_rounded, 0),
                      _chip("Living Room", Icons.chair_outlined, 1),
                      _chip("Bedroom", Icons.bed_outlined, 2),
                      _chip("", Icons.more_horiz, 3, small: true),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                /// DEVICE LIST
                ...devices.map((item) {
                  return _deviceCard(
                    title: item["name"],
                    power: item["power"],
                    icon: item["icon"],
                    isOn: item["status"],
                  );
                }).toList(),

                SizedBox(height: 18.h),

                /// FOOTER SAVE ENERGY
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F7FF),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 62.w,
                        height: 62.w,
                        decoration: const BoxDecoration(
                          color: Color(0xffE7F7EB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.eco,
                          color: const Color(0xff22C55E),
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You're saving energy!",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xff6B7280),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Great job! You've saved ",
                                  ),
                                  TextSpan(
                                    text: "18%",
                                    style: TextStyle(
                                      color: const Color(0xff22C55E),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " compared to yesterday.",
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _topIcon(IconData icon) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Icon(icon, size: 24.sp),
    );
  }

  Widget _chip(String text, IconData icon, int index, {bool small = false}) {
    final selected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(
          horizontal: small ? 18.w : 18.w,
          vertical: 14.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xffF0FDF4)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? const Color(0xff86EFAC) : const Color(0xffE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: selected
                  ? const Color(0xff22C55E)
                  : const Color(0xff374151),
            ),
            if (!small) SizedBox(width: 10.w),
            if (!small)
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? const Color(0xff22C55E)
                      : const Color(0xff374151),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _deviceCard({
    required String title,
    required String power,
    required IconData icon,
    required bool isOn,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 110.w,
            height: 110.w,
            decoration: BoxDecoration(
              color: isOn ? const Color(0xffEEF8EE) : const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              icon,
              size: 48.sp,
              color: isOn ? const Color(0xff16A34A) : const Color(0xff6B7280),
            ),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isOn
                        ? const Color(0xffEEF8EE)
                        : const Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isOn
                              ? const Color(0xff22C55E)
                              : const Color(0xff9CA3AF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isOn ? "ON" : "OFF",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: isOn
                              ? const Color(0xff16A34A)
                              : const Color(0xff6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                Text(
                  "Power",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),
                SizedBox(height: 4.h),

                Text(
                  power,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: isOn
                        ? const Color(0xff16A34A)
                        : const Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Transform.scale(
                scale: 1.1,
                child: Switch(
                  value: isOn,
                  onChanged: (_) {},
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xff22C55E),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xffD1D5DB),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: const Color(0xffE5E7EB)),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xff6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
