import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/model/energy_model.dart';

class AnalyticsPage extends StatefulWidget {
  final String deviceId;

  const AnalyticsPage({super.key, required this.deviceId});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  /// ======================================================
  /// CONFIG
  /// ======================================================

  final String baseUrl = "http://43.157.213.11:8080";

  final String apiKey =
      "001_087962aa8dd39c96957fd20cff8c8b76d4c8bad7235c29b04933fd60e92d2cc36a5def37d043817b91faec5b4a81354a1a71c0dc0dba02533c8d6f84ceb856a8";

  /// ======================================================
  /// FILTER
  /// ======================================================

  int selectedFilter = 2;

  final List<String> filters = ["10 Minutes", "30 Minutes", "1 Hour", "Daily"];

  /// ======================================================
  /// DATA
  /// ======================================================

  List<EnergyData> rawData = [];
  List<FlSpot> chartData = [];

  double totalEnergy = 0;
  double peakPower = 0;
  double avgPower = 0;

  bool isLoading = true;

  /// ======================================================
  /// INIT
  /// ======================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  /// ======================================================
  /// LOAD API
  /// ======================================================

  Future<void> loadData({String bucket = "1h"}) async {
    setState(() => isLoading = true);

    try {
      /// ======================================================
      /// 🔥 FIXED RANGE UNTUK TEST DB
      /// karena data DB ada di 2026-05-02
      /// ======================================================
      final now = DateTime(2026, 5, 3, 23, 59, 59);

      DateTime from;

      switch (bucket) {
        /// 🔥 10 MINUTES
        case "10m":
          from = now.subtract(const Duration(days: 1));
          break;

        case "30m":
          from = now.subtract(const Duration(days: 30));
          break;

        case "1h":
          from = now.subtract(const Duration(days: 30));
          break;

        case "1d":
          from = now.subtract(const Duration(days: 30));
          break;

        default:
          from = now.subtract(const Duration(days: 30));
      }

      final uri = Uri.parse('$baseUrl/api/graph/pzem004t').replace(
        queryParameters: {
          'deviceId': widget.deviceId,
          'from': _toWibIso(from),
          'to': _toWibIso(now),
          'bucket': bucket,
        },
      );

      /// 🔥 DEBUG URL
      debugPrint("GRAPH URL:");
      debugPrint(uri.toString());

      final response = await http.get(
        uri,
        headers: {'x-api-key': apiKey, 'accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }

      final body = jsonDecode(response.body);

      debugPrint("GRAPH RESPONSE:");
      debugPrint(response.body);

      final List data = body['data'] ?? [];

      final list = data.map((e) => EnergyData.fromJson(e)).toList();

      setState(() {
        rawData = list;

        chartData = _convertToSpots(list);

        totalEnergy = _totalEnergy(list);

        peakPower = _peakPower(list);

        avgPower = _avgPower(list);

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Analytics Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  /// ======================================================
  /// FILTER MAP
  /// ======================================================

  String _getRange(int index) {
    switch (index) {
      case 0:
        return "10m";

      case 1:
        return "30m";

      case 2:
        return "1h";

      case 3:
        return "1d";

      default:
        return "1h";
    }
  }

  /// ======================================================
  /// WIB FORMAT
  /// ======================================================

  String _toWibIso(DateTime dt) {
    final wib = dt.toUtc().add(const Duration(hours: 7));

    return wib.toIso8601String().replaceFirst('Z', '+07:00');
  }

  /// ======================================================
  /// CALCULATE
  /// ======================================================

  List<FlSpot> _convertToSpots(List<EnergyData> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.power);
    }).toList();
  }

  double _totalEnergy(List<EnergyData> data) {
    return data.fold(0, (sum, e) => sum + e.energy);
  }

  double _peakPower(List<EnergyData> data) {
    if (data.isEmpty) return 0;

    return data.map((e) => e.power).reduce((a, b) => a > b ? a : b);
  }

  double _avgPower(List<EnergyData> data) {
    if (data.isEmpty) return 0;

    return data.map((e) => e.power).reduce((a, b) => a + b) / data.length;
  }

  double get currentPower {
    if (rawData.isEmpty) return 0;

    return rawData.last.power;
  }

  double get totalCost {
    return totalEnergy * 1444;
  }

  /// ======================================================
  /// UI
  /// ======================================================

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

                /// ======================================================
                /// TOP BAR
                /// ======================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topButton(Icons.arrow_back_ios_new_rounded),
                    _topButton(Icons.calendar_today_outlined),
                  ],
                ),

                SizedBox(height: 24.h),

                /// ======================================================
                /// HEADER
                /// ======================================================
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
                            "Realtime energy insights from FlexySave",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

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
                        Icons.bolt_rounded,
                        size: 46.sp,
                        color: const Color(0xff3B82F6),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                /// ======================================================
                /// FILTER
                /// ======================================================
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
                          onTap: () async {
                            setState(() {
                              selectedFilter = index;
                            });

                            await loadData(bucket: _getRange(index));
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
                            child: Center(
                              child: Text(
                                filters[index],
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xff4B5563),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 22.h),

                /// ======================================================
                /// MAIN CARD
                /// ======================================================
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Energy Usage",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${totalEnergy.toStringAsFixed(2)} kWh",
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              Text(
                                "Rp ${totalCost.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      SizedBox(
                        height: 260.h,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : LineChart(_usageChart()),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// ======================================================
                /// STATS
                /// ======================================================
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Peak",
                        "${peakPower.toStringAsFixed(1)} W",
                        "Max",
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: _statCard(
                        "Average",
                        "${avgPower.toStringAsFixed(1)} W",
                        "Realtime",
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: _statCard(
                        "Current",
                        "${currentPower.toStringAsFixed(1)} W",
                        "Now",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ======================================================
  /// CHART
  /// ======================================================

  LineChartData _usageChart() {
    return LineChartData(
      minX: 0,

      maxX: chartData.isEmpty ? 6 : chartData.length.toDouble() - 1,

      minY: 0,

      maxY: peakPower <= 0 ? 100 : peakPower * 1.2,

      clipData: FlClipData.all(),

      backgroundColor: Colors.transparent,

      borderData: FlBorderData(show: false),

      /// ======================================================
      /// GRID
      /// ======================================================
      gridData: FlGridData(
        show: true,

        drawVerticalLine: false,

        horizontalInterval: peakPower <= 0 ? 20 : peakPower / 4,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xffCBD5E1).withOpacity(0.35),

            strokeWidth: 1.2,

            dashArray: [6, 6],
          );
        },
      ),

      /// ======================================================
      /// TITLES
      /// ======================================================
      titlesData: FlTitlesData(show: false),

      /// ======================================================
      /// TOUCH
      /// ======================================================
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,

        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),

          getTooltipItems: (spots) {
            return spots.map((spot) {
              return LineTooltipItem(
                "${spot.y.toStringAsFixed(1)} W",

                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            }).toList();
          },
        ),
      ),

      /// ======================================================
      /// LINE
      /// ======================================================
      lineBarsData: [
        /// 🔥 GLOW LINE
        LineChartBarData(
          spots: chartData,

          isCurved: true,

          curveSmoothness: 0.35,

          barWidth: 10,

          color: const Color(0xff22C55E).withOpacity(0.12),

          dotData: FlDotData(show: false),
        ),

        /// 🔥 MAIN LINE
        LineChartBarData(
          spots: chartData,

          isCurved: true,

          curveSmoothness: 0.35,

          preventCurveOverShooting: true,

          barWidth: 4.5,

          isStrokeCapRound: true,

          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,

            colors: [Color(0xff22C55E), Color(0xff3B82F6)],
          ),

          /// ======================================================
          /// AREA
          /// ======================================================
          belowBarData: BarAreaData(
            show: true,

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              colors: [
                const Color(0xff22C55E).withOpacity(0.28),

                const Color(0xff3B82F6).withOpacity(0.02),
              ],
            ),
          ),

          /// ======================================================
          /// DOTS
          /// ======================================================
          dotData: FlDotData(
            show: true,

            getDotPainter: (spot, percent, bar, index) {
              return FlDotCirclePainter(
                radius: 3.5,

                color: Colors.white,

                strokeWidth: 2.5,

                strokeColor: const Color(0xff22C55E),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ======================================================
  /// WIDGETS
  /// ======================================================

  Widget _statCard(String title, String value, String sub) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Text(title),

          SizedBox(height: 6.h),

          Text(
            value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),

          Text(sub),
        ],
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
}
