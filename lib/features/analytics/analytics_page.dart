import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int selectedFilter = 2;

  final List<String> filters = ["10 minutes", "30 minutes", "1 hour", "Daily"];

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                /// TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topButton(Icons.arrow_back_ios_new_rounded),
                    _topButton(Icons.calendar_today_outlined),
                  ],
                ),

                SizedBox(height: 24.h),

                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Energy Analytics",
                            style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff0F172A),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Real-time insights into your energy usage",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Container(
                      width: 110.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffEEF8EE), Color(0xffDCEAFF)],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 46.sp,
                        color: const Color(0xff3B82F6),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                /// FILTER TABS
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: Row(
                    children: List.generate(filters.length, (index) {
                      final selected = selectedFilter == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xff22C55E),
                                        Color(0xff3B82F6),
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  index == 3
                                      ? Icons.calendar_today_outlined
                                      : Icons.schedule,
                                  size: 18.sp,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xff4B5563),
                                ),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    filters[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xff4B5563),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 22.h),

                /// MAIN CHART CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Energy Usage",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff22C55E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Live • Updated just now",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "2.45 kWh",
                                style: TextStyle(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "Current Usage",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xff6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      SizedBox(height: 300.h, child: LineChart(_usageChart())),

                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Total Usage (kWh)",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// STATS
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        title: "Peak Usage",
                        value: "2.83 kWh",
                        sub: "8:58 AM",
                        badge: "↑ 12%",
                        color: const Color(0xff22C55E),
                        icon: Icons.trending_up,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _statCard(
                        title: "Average Usage",
                        value: "1.62 kWh",
                        sub: "Per Hour",
                        badge: "↓ 8%",
                        color: const Color(0xff3B82F6),
                        icon: Icons.graphic_eq,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _statCard(
                        title: "Total Usage",
                        value: "1.62 kWh",
                        sub: "This Hour",
                        badge: "↑ 5%",
                        color: const Color(0xff8B5CF6),
                        icon: Icons.bolt,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                /// INSIGHTS
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                              ),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Energy Insights",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  "AI-powered analysis",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xff6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffDCFCE7),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Good",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff16A34A),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff22C55E),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      _insightTile(
                        icon: Icons.check_circle_outline,
                        color: const Color(0xff22C55E),
                        title: "Usage is 8% lower than the previous hour.",
                        subtitle: "Great job! You're conserving more energy.",
                      ),

                      _divider(),

                      _insightTile(
                        icon: Icons.access_time,
                        color: const Color(0xff3B82F6),
                        title: "Peak usage occurred at 8:58 AM.",
                        subtitle:
                            "Consider shifting high-power activities to off-peak hours.",
                      ),

                      _divider(),

                      _insightTile(
                        icon: Icons.eco_outlined,
                        color: const Color(0xff8B5CF6),
                        title: "You've saved 0.35 kWh today.",
                        subtitle:
                            "Keep it up! Small changes lead to big savings.",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topButton(IconData icon) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(icon),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String sub,
    required String badge,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xff6B7280)),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            sub,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xff6B7280)),
          ),
          SizedBox(height: 12.h),
          Text(
            badge,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right, color: const Color(0xff9CA3AF)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1.h, color: const Color(0xffEEF2F7));
  }

  LineChartData _usageChart() {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 3.2,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 0.75,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: const Color(0xffEEF2F7), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 34,
            interval: 0.75,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(2),
                style: const TextStyle(fontSize: 10, color: Color(0xff9CA3AF)),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const times = [
                "8:30 AM",
                "8:45 AM",
                "9:00 AM",
                "9:15 AM",
                "",
                "",
                "9:30 AM",
              ];

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  times[value.toInt()],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 0.75),
            FlSpot(1, 2.2),
            FlSpot(2, 3.0),
            FlSpot(3, 2.4),
            FlSpot(4, 2.6),
            FlSpot(5, 1.2),
            FlSpot(6, 1.45),
          ],
          isCurved: true,
          barWidth: 4,
          gradient: const LinearGradient(
            colors: [Color(0xff22C55E), Color(0xff3B82F6)],
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xff22C55E).withOpacity(0.15),
                const Color(0xff3B82F6).withOpacity(0.02),
              ],
            ),
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, p, bar, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: Colors.white,
                strokeWidth: 3,
                strokeColor: index == 2
                    ? const Color(0xff22C55E)
                    : const Color(0xff3B82F6),
              );
            },
          ),
        ),
      ],
    );
  }
}
