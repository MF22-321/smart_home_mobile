import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/services/device_service.dart';

class EnvironmentPage extends StatelessWidget {
  final DeviceDataService deviceService;

  const EnvironmentPage({super.key, required this.deviceService});

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

                        return StreamBuilder<Map<String, dynamic>>(
                          stream: deviceService.environmentStream,
                          builder: (context, snapshot) {
                            /// 🔥 AMBIL DATA DARI CACHE (BUKAN SNAPSHOT)
                            final data = deviceService.getEnv('flexy-004');

                            if (data.isEmpty) {
                              return const Center(
                                child: Text("Waiting for device data..."),
                              );
                            }

                            final temp = (data['temperature'] is num)
                                ? (data['temperature'] as num).toStringAsFixed(
                                    1,
                                  )
                                : "--";

                            final hum = (data['humidity'] is num)
                                ? (data['humidity'] as num).toStringAsFixed(0)
                                : "--";

                            final motion = data['motion'] == true
                                ? "Detected"
                                : "No Motion";

                            final fan = data['fan'] ?? "OFF";

                            return GridView.count(
                              crossAxisCount: crossCount,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: ratio,
                              children: [
                                /// 🌡️ TEMPERATURE
                                SensorCard(
                                  title: "Temperature",
                                  sub: "(°C)",
                                  value: "$temp°C",
                                  icon: Icons.thermostat_outlined,
                                  color: const Color(0xff22C55E),
                                  badge: _getTempStatus(data['temperature']),
                                  badgeColor: const Color(0xff22C55E),
                                  type: SensorType.chart,
                                ),

                                /// 💧 HUMIDITY
                                SensorCard(
                                  title: "Humidity",
                                  sub: "(%)",
                                  value: "$hum%",
                                  icon: Icons.water_drop_outlined,
                                  color: const Color(0xff2563EB),
                                  badge: _getHumidityStatus(data['humidity']),
                                  badgeColor: const Color(0xff22C55E),
                                  type: SensorType.chartBlue,
                                ),

                                /// 🌀 FAN STATUS
                                SensorCard(
                                  title: "Fan Status",
                                  sub: "(AUTO)",
                                  value: fan,
                                  icon: Icons.toys,
                                  color: fan == "ON"
                                      ? const Color(0xff3B82F6)
                                      : const Color(0xff9CA3AF),
                                  badge: fan,
                                  badgeColor: fan == "ON"
                                      ? const Color(0xff3B82F6)
                                      : const Color(0xff9CA3AF),
                                  message: fan == "ON"
                                      ? "Cooling active"
                                      : "Fan idle",
                                  type: SensorType.message,
                                ),

                                /// 🚶 PIR
                                SensorCard(
                                  title: "Motion Detection",
                                  sub: "(PIR)",
                                  value: motion,
                                  icon: Icons.directions_walk,
                                  color: data['motion'] == true
                                      ? const Color(0xffEF4444)
                                      : const Color(0xff22C55E),
                                  badge: data['motion'] == true
                                      ? "Active"
                                      : "Idle",
                                  badgeColor: data['motion'] == true
                                      ? const Color(0xffEF4444)
                                      : const Color(0xff22C55E),
                                  message: data['motion'] == true
                                      ? "Movement detected"
                                      : "No movement",
                                  type: SensorType.messageGreen,
                                ),
                              ],
                            );
                          },
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

  /// ===============================
  /// STATUS LOGIC
  /// ===============================
  String _getTempStatus(dynamic temp) {
    final t = temp is num ? temp.toDouble() : 0;
    if (t > 30) return "Hot";
    if (t < 18) return "Cold";
    return "Normal";
  }

  String _getHumidityStatus(dynamic hum) {
    final h = hum is num ? hum.toDouble() : 0;
    if (h > 70) return "High";
    if (h < 30) return "Low";
    return "Normal";
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1D9E75), Color(0xff3B82F6)],
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
          Text(
            "Environment Monitoring",
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
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
      child: const Text("Live data from MQTT"),
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
      child: const Text("Environment stable"),
    );
  }
}

/// ===============================
/// SENSOR CARD (TIDAK DIUBAH)
/// ===============================
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      /// 🔥 PENTING: biar tidak overflow
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ WAJIB
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================
          /// ICON + BADGE
          /// =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.12),
                ),
                child: Icon(icon, color: color, size: 26.sp),
              ),

              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// =========================
          /// TITLE
          /// =========================
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),

          SizedBox(height: 2.h),

          Text(
            sub,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),

          SizedBox(height: 10.h),

          /// =========================
          /// VALUE (BIG)
          /// =========================
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 34.sp, // 🔥 besar tapi aman
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          /// =========================
          /// MESSAGE / CHART
          /// =========================
          if (type == SensorType.message || type == SensorType.messageGreen)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                message ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.3,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          if (type == SensorType.chart || type == SensorType.chartBlue)
            SizedBox(
              height: 40.h, // 🔥 FIX biar tidak overflow
              child: LineChart(_spark(color)),
            ),
        ],
      ),
    );
  }

  /// =========================
  /// MINI CHART
  /// =========================
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
          barWidth: 2.5,
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
