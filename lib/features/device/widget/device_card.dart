import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/home/widget/glass_card.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: GlassCard(
            padding: EdgeInsets.all(18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT
                Column(
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
                    SizedBox(height: 12.h),
                    Icon(
                      Icons.home_outlined,
                      size: 20.sp,
                      color: Colors.black54,
                    ),
                  ],
                ),

                /// RIGHT BUTTON
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.orange : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
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
