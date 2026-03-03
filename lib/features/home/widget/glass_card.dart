import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GlassCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: padding ?? EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: Colors.white.withOpacity(0.7),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
