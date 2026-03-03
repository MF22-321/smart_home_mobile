import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/glass_card.dart';

class ControllerCard extends StatelessWidget {
  const ControllerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 205.h,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: [
        _controllerSlide(
          icon: Icons.arrow_upward,
          title: "Temperature",
          value: "19°C",
          subtitle: "Outside 9°C",
        ),
        _controllerSlide(
          icon: Icons.arrow_downward,
          title: "Energy",
          value: "20 kWh",
          subtitle: "Cost \$30",
        ),
        _controllerSlide(
          icon: Icons.arrow_upward,
          title: "Humidity",
          value: "35%",
          subtitle: "Outside 47%",
        ),
      ],
    );
  }

  Widget _controllerSlide({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return SizedBox(
      height: 200.h,
      child: GlassCard(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              icon,
                              size: 16.sp,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              28.sp, // 🔥 sedikit turun lagi biar aman total
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black45),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
