import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/home/widget/glass_card.dart';

class DeviceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const DeviceTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GlassCard(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.devices, size: 20.sp, color: Colors.black87),
            ),

            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),

            Switch(
              value: value,
              activeColor: AppColors.orange,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
