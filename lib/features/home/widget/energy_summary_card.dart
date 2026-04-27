import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnergySummaryCard extends StatelessWidget {
  const EnergySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 340;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff22C55E), Color(0xff0EA5E9)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: isSmall ? _mobileLayout() : _desktopLayout(),
        );
      },
    );
  }

  /// NORMAL WIDTH
  Widget _desktopLayout() {
    return Row(
      children: [
        Expanded(child: _leftSection()),

        Container(width: 1.w, height: 120.h, color: Colors.white24),

        SizedBox(width: 18.w),

        Expanded(child: _rightSection()),
      ],
    );
  }

  /// SMALL PHONE
  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _leftSection(),

        SizedBox(height: 18.h),

        Container(height: 1.h, width: double.infinity, color: Colors.white24),

        SizedBox(height: 18.h),

        _rightSection(),
      ],
    );
  }

  Widget _leftSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Electricity Usage",
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 14.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "18.6",
              style: TextStyle(
                fontSize: 40.sp,
                height: 1,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(width: 6.w),

            Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Text(
                "kWh",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _rightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Estimated Bill",
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 14.h),

        Text(
          "₹1,248",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 32.sp,
            height: 1,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
