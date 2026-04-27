import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveDevicesCard extends StatelessWidget {
  const ActiveDevicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xffEEF4FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.power_outlined,
                  size: 22.sp,
                  color: const Color(0xff3B82F6),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  "Active Devices",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff111827),
                  ),
                ),
              ),

              Text(
                "3 Online",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff22C55E),
                ),
              ),

              SizedBox(width: 4.w),

              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: const Color(0xff22C55E),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          /// ITEMS
          _deviceItem(
            icon: Icons.light_outlined,
            iconBg: const Color(0xffEEF9F0),
            iconColor: const Color(0xff22C55E),
            title: "Lamp",
            room: "Living Room",
            isOn: true,
          ),

          _deviceItem(
            icon: Icons.outlet_outlined,
            iconBg: const Color(0xffEEF4FF),
            iconColor: const Color(0xff3B82F6),
            title: "Socket",
            room: "Study Room",
            isOn: true,
          ),

          _deviceItem(
            icon: Icons.toys_outlined,
            iconBg: const Color(0xffEEF4FF),
            iconColor: const Color(0xff3B82F6),
            title: "Fan",
            room: "Bedroom",
            isOn: false,
          ),

          SizedBox(height: 10.h),

          /// FOOTER
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View all devices",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2563EB),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.chevron_right,
                  size: 18.sp,
                  color: const Color(0xff2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String room,
    required bool isOn,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xffF1F3F5)),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 24.sp, color: iconColor),
          ),

          SizedBox(width: 14.w),

          /// NAME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff111827),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  room,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          /// STATUS
          Row(
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xffD1D5DB),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                isOn ? "ON" : "OFF",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xff9CA3AF),
                ),
              ),
            ],
          ),

          SizedBox(width: 14.w),

          /// SWITCH
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isOn,
              onChanged: (_) {},
              activeColor: Colors.white,
              activeTrackColor: const Color(0xff22C55E),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xffC7CDD8),
            ),
          ),
        ],
      ),
    );
  }
}
