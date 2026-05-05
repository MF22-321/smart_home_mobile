import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';

/// ================= MODEL =================
class EnergyData {
  final double power;
  final double energy;
  final DateTime time;

  EnergyData({required this.power, required this.energy, required this.time});

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      power: json['power'].toDouble(),
      energy: json['energy'].toDouble(),
      time: DateTime.parse(json['created_at']),
    );
  }
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int selectedFilter = 2;

  final List<String> filters = ["10 minutes", "30 minutes", "1 hour", "Daily"];

  /// 🔥 DATA
  List<EnergyData> rawData = [];
  List<FlSpot> chartData = [];

  double totalEnergy = 0;
  double peakPower = 0;
  double avgPower = 0;

  bool isLoading = true;

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// ================= FETCH API =================
  Future<void> loadData({String range = "1h"}) async {
    setState(() => isLoading = true);

    final url = Uri.parse(
      "http://YOUR_API_URL/pzem?device_id=flexy-001&range=$range",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      final list = data.map((e) => EnergyData.fromJson(e)).toList();

      setState(() {
        rawData = list;
        chartData = _convertToSpots(list);
        totalEnergy = _totalEnergy(list);
        peakPower = _peakPower(list);
        avgPower = _avgPower(list);
        isLoading = false;
      });
    }
  }

  /// ================= FILTER =================
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

  /// ================= CALC =================
  List<FlSpot> _convertToSpots(List<EnergyData> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.power);
    }).toList();
  }

  double _totalEnergy(List<EnergyData> data) {
    return data.fold(0, (sum, e) => sum + e.energy);
  }

  double _peakPower(List<EnergyData> data) {
    return data.isEmpty
        ? 0
        : data.map((e) => e.power).reduce((a, b) => a > b ? a : b);
  }

  double _avgPower(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    return data.map((e) => e.power).reduce((a, b) => a + b) / data.length;
  }

  double get currentPower => rawData.isNotEmpty ? rawData.last.power : 0;

  double get totalCost => totalEnergy * 1444;

  /// ================= UI =================
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

                /// HEADER (TIDAK DIUBAH)
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

                /// FILTER
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
                            setState(() => selectedFilter = index);

                            await loadData(range: _getRange(index));
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

                /// MAIN CARD
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

                /// STATS
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

  /// ================= CHART =================
  LineChartData _usageChart() {
    return LineChartData(
      minX: 0,
      maxX: chartData.isEmpty ? 6 : chartData.length.toDouble(),
      minY: 0,
      maxY: peakPower == 0 ? 100 : peakPower + 50,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: true,
          barWidth: 4,
          gradient: const LinearGradient(
            colors: [Color(0xff22C55E), Color(0xff3B82F6)],
          ),
          belowBarData: BarAreaData(show: true),
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

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
