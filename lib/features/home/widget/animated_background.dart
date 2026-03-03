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
      duration: const Duration(seconds: 20),
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
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDEE8)],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Stack(
                children: [
                  /// PARTICLE 1
                  Positioned(
                    top: -80.h + (_controller.value * 40),
                    left: -60.w,
                    child: _blurCircle(
                      250.w,
                      const Color(0xFF6C63FF).withOpacity(0.25),
                    ),
                  ),

                  /// PARTICLE 2
                  Positioned(
                    top: 300.h - (_controller.value * 60),
                    right: -70.w,
                    child: _blurCircle(
                      200.w,
                      const Color(0xFF8A7BFF).withOpacity(0.2),
                    ),
                  ),

                  /// PARTICLE 3
                  Positioned(
                    bottom: -100.h + (_controller.value * 50),
                    left: 80.w,
                    child: _blurCircle(
                      180.w,
                      const Color(0xFF5A54E8).withOpacity(0.2),
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
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
