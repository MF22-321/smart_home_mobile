// environment_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class EnvironmentPage extends StatelessWidget {
  const EnvironmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 120.h),
          child: Column(
            children: [
              _headerSection(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    _statusCard(),

                    SizedBox(height: 20.h),

                    /// RESPONSIVE GRID
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        int crossCount = 2;
                        double ratio = 0.58;

                        if (width < 360) {
                          ratio = 0.48;
                        } else if (width < 430) {
                          ratio = 0.55;
                        } else if (width < 600) {
                          ratio = 0.60;
                        } else {
                          crossCount = 3;
                          ratio = 0.72;
                        }

                        return GridView.count(
                          crossAxisCount: crossCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: ratio,
                          children: const [
                            SensorCard(
                              title: "Temperature",
                              sub: "(°C)",
                              value: "24.6°C",
                              icon: Icons.thermostat_outlined,
                              color: Color(0xff22C55E),
                              badge: "Normal",
                              badgeColor: Color(0xff22C55E),
                              type: SensorType.chart,
                            ),

                            SensorCard(
                              title: "Humidity",
                              sub: "(%)",
                              value: "52%",
                              icon: Icons.water_drop_outlined,
                              color: Color(0xff2563EB),
                              badge: "Normal",
                              badgeColor: Color(0xff22C55E),
                              type: SensorType.chartBlue,
                            ),

                            SensorCard(
                              title: "Light Status",
                              sub: "(LDR)",
                              value: "Bright",
                              icon: Icons.lightbulb_outline,
                              color: Color(0xffF4B000),
                              badge: "Alert",
                              badgeColor: Color(0xffF4B000),
                              message:
                                  "Ambient light is high\nConsider closing blinds",
                              type: SensorType.message,
                            ),

                            SensorCard(
                              title: "Motion Detection",
                              sub: "(PIR)",
                              value: "Detected",
                              icon: Icons.directions_walk,
                              color: Color(0xff22C55E),
                              badge: "Normal",
                              badgeColor: Color(0xff22C55E),
                              message: "Motion was detected\nJust now",
                              type: SensorType.messageGreen,
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    _footerCard(),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff22C55E), Color(0xff3B82F6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FlexySave",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.notifications_none, color: Colors.white, size: 28.sp),
            ],
          ),

          SizedBox(height: 26.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Environment Monitoring",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Real-time updates from your smart sensors",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  size: 54.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Container(
            width: 14.w,
            height: 14.w,
            decoration: const BoxDecoration(
              color: Color(0xff22C55E),
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Systems Normal",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff166534),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Last updated: Today, 9:41 AM",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xffEEF8EE),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              "Live",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff15803D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffEEF8EE), Color(0xffDCEAFF)],
        ),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(Icons.eco, color: const Color(0xff22C55E), size: 30.sp),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Great Environment!",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff15803D),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "All parameters are in normal range.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum SensorType { chart, chartBlue, message, messageGreen }

class SensorCard extends StatelessWidget {
  final String title;
  final String sub;
  final String value;
  final IconData icon;
  final Color color;
  final String badge;
  final Color badgeColor;
  final String? message;
  final SensorType type;

  const SensorCard({
    super.key,
    required this.title,
    required this.sub,
    required this.value,
    required this.icon,
    required this.color,
    required this.badge,
    required this.badgeColor,
    this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP
          Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.08),
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: FittedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14.sp,
                            color: badgeColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            badge,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),

          SizedBox(height: 2.h),

          Text(
            sub,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),

          SizedBox(height: 10.h),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: type == SensorType.chart || type == SensorType.chartBlue
                ? SizedBox(
                    width: double.infinity,
                    child: LineChart(_spark(color)),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      message ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        height: 1.4,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "Updated just now",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _spark(Color c) {
    return LineChartData(
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 5,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          barWidth: 3,
          color: c,
          spots: const [
            FlSpot(0, 1.5),
            FlSpot(1, 3.2),
            FlSpot(2, 1.7),
            FlSpot(3, 3.8),
            FlSpot(4, 2.4),
            FlSpot(5, 4.0),
          ],
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: true, color: c.withOpacity(0.08)),
        ),
      ],
    );
  }
}
