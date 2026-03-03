import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ControllerItem extends StatelessWidget {
  final String title;
  final String value;

  const ControllerItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
