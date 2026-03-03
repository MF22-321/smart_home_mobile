import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutomationTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AutomationTab({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ["Ruang Tamu", "Kamar Depan", "Kamar Mandi", "Dapur"];

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffF2994A)
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
