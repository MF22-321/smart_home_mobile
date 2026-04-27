import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffF8FAFC), Color(0xffF3F4F6), Color(0xffEEF2F7)],
        ),
      ),
      child: Stack(
        children: [
          /// PARTICLES
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Stack(
                children: [
                  /// TOP LEFT GREEN
                  Positioned(
                    top: -100.h + (_controller.value * 35),
                    left: -70.w,
                    child: _blurCircle(
                      240.w,
                      const Color(0xff22C55E).withOpacity(0.08),
                    ),
                  ),

                  /// RIGHT BLUE
                  Positioned(
                    top: 220.h - (_controller.value * 45),
                    right: -90.w,
                    child: _blurCircle(
                      220.w,
                      const Color(0xff0EA5E9).withOpacity(0.08),
                    ),
                  ),

                  /// BOTTOM LEFT GREEN
                  Positioned(
                    bottom: -80.h + (_controller.value * 40),
                    left: 60.w,
                    child: _blurCircle(
                      180.w,
                      const Color(0xff16A34A).withOpacity(0.06),
                    ),
                  ),

                  /// CENTER LIGHT BLUE
                  Positioned(
                    top: 420.h + (_controller.value * 20),
                    left: 100.w,
                    child: _blurCircle(
                      160.w,
                      const Color(0xff38BDF8).withOpacity(0.05),
                    ),
                  ),
                ],
              );
            },
          ),

          widget.child,
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
