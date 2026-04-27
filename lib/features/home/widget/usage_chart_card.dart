import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsageChartCard extends StatelessWidget {
  const UsageChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: const BoxDecoration(
                  color: Color(0xffEEF4FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.show_chart,
                  size: 22.sp,
                  color: Color(0xff3B82F6),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  "Today's Usage",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff111827),
                  ),
                ),
              ),

              Text(
                "18.6 kWh",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff22C55E),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// FILTER
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE5E7EB)),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.sp,
                    color: const Color(0xff6B7280),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),

          /// CHART
          Expanded(
            child: Stack(
              children: [
                LineChart(_chartData()),

                /// TOOLTIP FIXED
                Positioned(
                  top: 18.h,
                  left: 145.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      "1.8 kWh",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff22C55E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 2.2,

      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.5,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10, color: Color(0xff9CA3AF)),
              );
            },
          ),
        ),

        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 4,
            getTitlesWidget: (value, meta) {
              final labels = {
                0: "12 AM",
                4: "4 AM",
                8: "8 AM",
                12: "12 PM",
                16: "4 PM",
                20: "8 PM",
                24: "12 AM",
              };

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  labels[value.toInt()] ?? "",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff9CA3AF),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          barWidth: 3,
          spots: const [
            FlSpot(0, 0.5),
            FlSpot(2, 0.6),
            FlSpot(4, 0.4),
            FlSpot(6, 0.5),
            FlSpot(8, 0.9),
            FlSpot(10, 1.4),
            FlSpot(12, 1.8),
            FlSpot(14, 1.7),
            FlSpot(16, 1.5),
            FlSpot(18, 1.3),
            FlSpot(20, 1.0),
            FlSpot(22, 0.4),
            FlSpot(24, 0.5),
          ],
          gradient: const LinearGradient(
            colors: [Color(0xff22C55E), Color(0xff0EA5E9)],
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xff22C55E).withOpacity(0.25),
                const Color(0xff0EA5E9).withOpacity(0.02),
              ],
            ),
          ),

          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => spot.x == 12,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: const Color(0xff22C55E),
                strokeWidth: 3,
                strokeColor: Colors.white,
              );
            },
          ),
        ),
      ],

      extraLinesData: ExtraLinesData(
        verticalLines: [
          VerticalLine(
            x: 12,
            color: const Color(0xffD1D5DB),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ],
      ),
    );
  }
}
