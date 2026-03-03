import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home, 0),
          navItem(Icons.check_box, 1),
          navItem(Icons.devices, 2),
          navItem(Icons.person, 3),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 24.sp,
        color: selectedIndex == index ? AppColors.orange : Colors.grey,
      ),
    );
  }
}
