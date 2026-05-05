import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/services/device_service.dart';

class EnergySummaryCard extends StatelessWidget {
  final DeviceDataService deviceService;

  /// 🔥 Mapping nama device
  final Map<String, String> deviceNames = {
    "flexy-001": "Living Room",
    "flexy-002": "Bedroom",
  };

  EnergySummaryCard({super.key, required this.deviceService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: deviceService.environmentStream,
      builder: (context, snapshot) {
        /// 🔥 LANGSUNG AMBIL DEVICE (NO DELAY UI)
        final devices = deviceService.getAllDevices();

        /// 🔥 FILTER: hanya yang ada power (PZEM)
        final validDevices = devices.where((d) {
          final env = deviceService.getEnv(d.deviceId);
          return env.containsKey('power');
        }).toList();

        if (validDevices.isEmpty) {
          return _emptyState();
        }

        return Column(
          children: validDevices.map((d) {
            final env = deviceService.getEnv(d.deviceId);

            final energy = (env['energy'] ?? 0).toDouble();
            final power = (env['power'] ?? 0).toDouble();
            final cost = (env['cost'] ?? 0).toDouble();

            final name = deviceNames[d.deviceId] ?? d.deviceId;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildCard(name, energy, power, cost),
            );
          }).toList(),
        );
      },
    );
  }

  /// ================= CARD =================
  Widget _buildCard(String title, double energy, double power, double cost) {
    final config = _getRoomConfig(title);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config['gradient'],
        ),
        boxShadow: [
          BoxShadow(
            color: config['gradient'][0].withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(config['icon'], color: Colors.white, size: 24.sp),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Live",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// 🔥 POWER REALTIME
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "${power.toStringAsFixed(0)} W",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          /// ================= DATA =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ENERGY
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    energy.toStringAsFixed(3),
                    style: TextStyle(
                      fontSize: 34.sp,
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "kWh Usage",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                  ),
                ],
              ),

              /// COST (AKUMULATIF 🔥)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rp ${cost.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 28.sp,
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Accumulated Cost",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= EMPTY STATE =================
  Widget _emptyState() {
    return Container(
      padding: EdgeInsets.all(24.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.bolt_outlined, size: 40.sp, color: Colors.grey),
          SizedBox(height: 10.h),
          Text(
            "Waiting for energy data...",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ================= ROOM CONFIG =================
  Map<String, dynamic> _getRoomConfig(String title) {
    switch (title) {
      case "Living Room":
        return {
          "icon": Icons.chair_outlined,
          "gradient": [Color(0xff22C55E), Color(0xff3B82F6)],
        };

      case "Bedroom":
        return {
          "icon": Icons.bed_outlined,
          "gradient": [Color(0xff6366F1), Color(0xff8B5CF6)],
        };

      default:
        return {
          "icon": Icons.devices,
          "gradient": [Color(0xff0EA5E9), Color(0xff22C55E)],
        };
    }
  }
}
