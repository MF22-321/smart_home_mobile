import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/home/widget/glass_card.dart';

class AutomationCard extends StatefulWidget {
  final String title;
  final String task;
  final IconData icon;

  const AutomationCard({
    super.key,
    required this.title,
    required this.task,
    required this.icon,
  });

  @override
  State<AutomationCard> createState() => _AutomationCardState();
}

class _AutomationCardState extends State<AutomationCard> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: GlassCard(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.chevron_right, size: 18.sp),
              ],
            ),

            SizedBox(height: 4.h),

            Text(
              widget.task,
              style: TextStyle(fontSize: 11.sp, color: Colors.black54),
            ),

            SizedBox(height: 20.h),

            /// AUTOMATION FLOW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue, size: 20.sp),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, size: 18.sp, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Icon(widget.icon, size: 20.sp, color: Colors.black87),
                  ],
                ),

                Switch(
                  value: isOn,
                  activeColor: AppColors.orange,
                  onChanged: (val) {
                    setState(() {
                      isOn = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
