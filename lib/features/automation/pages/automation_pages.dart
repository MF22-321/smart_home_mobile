import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/services/device_service.dart';
import 'package:smart_home_mobile/services/mqtt_service.dart';

class AutomationPage extends StatefulWidget {
  final MqttService mqttService;
  final DeviceDataService deviceService;

  const AutomationPage({
    super.key,
    required this.mqttService,
    required this.deviceService,
  });

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  int selectedTab = 0;

  final List<String> deviceIds = [
    "flexy-001",
    "flexy-002",
    "flexy-003",
    "flexy-004",
    "flexy-005",
  ];

  /// =====================================================
  /// 🔥 TAB DEVICE
  /// =====================================================
  final List<Map<String, dynamic>> deviceTabs = [
    {"name": "All", "id": "all"},
    {"name": "Living", "id": "flexy-001"},
    {"name": "Bedroom", "id": "flexy-002"},
    {"name": "Kitchen", "id": "flexy-003"},
    {"name": "Outdoor Front", "id": "flexy-004"},
    {"name": "Outdoor Backyard", "id": "flexy-005"},
  ];

  /// =====================================================
  /// 🔥 SCHEDULE PER DEVICE
  /// =====================================================
  final Map<String, Map<String, TimeOfDay>> schedules = {
    "all": {
      "on": const TimeOfDay(hour: 18, minute: 0),
      "off": const TimeOfDay(hour: 6, minute: 0),
    },

    "flexy-001": {
      "on": const TimeOfDay(hour: 18, minute: 0),
      "off": const TimeOfDay(hour: 6, minute: 0),
    },

    "flexy-002": {
      "on": const TimeOfDay(hour: 20, minute: 0),
      "off": const TimeOfDay(hour: 5, minute: 30),
    },

    "flexy-003": {
      "on": const TimeOfDay(hour: 17, minute: 30),
      "off": const TimeOfDay(hour: 23, minute: 0),
    },

    "flexy-004": {
      "on": const TimeOfDay(hour: 18, minute: 0),
      "off": const TimeOfDay(hour: 5, minute: 0),
    },

    "flexy-005": {
      "on": const TimeOfDay(hour: 18, minute: 30),
      "off": const TimeOfDay(hour: 5, minute: 30),
    },
  };

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    /// 🔥 LOCAL SCHEDULER
    /// sementara masih Flutter side
    _startScheduler();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// =====================================================
  /// 🔥 SET MODE
  /// =====================================================
  void _setMode(bool auto) {
    final command = auto ? "AUTO" : "MANUAL";

    for (var id in deviceIds) {
      widget.mqttService.sendControl(id, "SYSTEM", command);
    }

    debugPrint("SYSTEM MODE => $command");
  }

  /// =====================================================
  /// 🔥 LOCAL SCHEDULER
  /// =====================================================
  void _startScheduler() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = TimeOfDay.now();

      final isAutomatic = widget.deviceService.isAutomationMode;

      /// 🔥 ONLY RUN IN AUTO MODE
      if (!isAutomatic) return;

      schedules.forEach((deviceId, time) {
        final on = time['on']!;
        final off = time['off']!;

        /// TURN ON
        if (now.hour == on.hour && now.minute == on.minute) {
          _trigger(deviceId, "ON");
        }

        /// TURN OFF
        if (now.hour == off.hour && now.minute == off.minute) {
          _trigger(deviceId, "OFF");
        }
      });
    });
  }

  /// =====================================================
  /// 🔥 MQTT TRIGGER
  /// =====================================================
  void _trigger(String deviceId, String command) {
    if (deviceId == "all") {
      for (var id in deviceIds) {
        widget.mqttService.sendControl(id, "LED", command);
      }
    } else {
      widget.mqttService.sendControl(deviceId, "LED", command);
    }

    debugPrint("AUTO TRIGGER => $deviceId | $command");
  }

  /// =====================================================
  /// 🔥 TIME PICKER
  /// =====================================================
  Future<void> _pickTime(bool isOn) async {
    final currentId = deviceTabs[selectedTab]['id'];

    final picked = await showTimePicker(
      context: context,
      initialTime: schedules[currentId]![isOn ? "on" : "off"]!,
    );

    if (picked != null) {
      setState(() {
        schedules[currentId]![isOn ? "on" : "off"] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentId = deviceTabs[selectedTab]['id'];

    /// 🔥 REALTIME SYSTEM MODE
    final isAutomatic = widget.deviceService.isAutomationMode;

    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),

          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120.h),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 10.h),

                /// =====================================================
                /// HEADER
                /// =====================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    _circleIcon(Icons.arrow_back_ios_new),

                    Text(
                      "Automation",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    _circleIcon(Icons.settings),
                  ],
                ),

                SizedBox(height: 30.h),

                /// =====================================================
                /// MODE TOGGLE
                /// =====================================================
                Container(
                  padding: EdgeInsets.all(6.w),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),

                    borderRadius: BorderRadius.circular(20.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),

                        blurRadius: 20,

                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: _modeButton(
                          title: "Automatic",

                          icon: Icons.auto_awesome,

                          selected: isAutomatic,

                          onTap: () {
                            _setMode(true);
                          },
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: _modeButton(
                          title: "Manual",

                          icon: Icons.touch_app,

                          selected: !isAutomatic,

                          onTap: () {
                            _setMode(false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// =====================================================
                /// STATUS CARD
                /// =====================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),

                  width: double.infinity,

                  padding: EdgeInsets.all(22.w),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),

                    gradient: LinearGradient(
                      colors: isAutomatic
                          ? [const Color(0xff22C55E), const Color(0xff3B82F6)]
                          : [const Color(0xffF97316), const Color(0xffEF4444)],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: isAutomatic
                            ? const Color(0xff22C55E).withOpacity(0.3)
                            : const Color(0xffEF4444).withOpacity(0.25),

                        blurRadius: 24,

                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Icon(
                            isAutomatic ? Icons.auto_awesome : Icons.touch_app,

                            color: Colors.white,

                            size: 26.sp,
                          ),

                          SizedBox(width: 10.w),

                          Text(
                            isAutomatic ? "Automatic Active" : "Manual Mode",

                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        isAutomatic
                            ? "ESP32 controls all devices automatically using motion sensor, LDR, and schedules."
                            : "You can now control all devices manually from the Device Page.",

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),

                          fontSize: 14.sp,

                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 28.h),

                /// =====================================================
                /// DEVICE TAB
                /// =====================================================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    children: List.generate(deviceTabs.length, (index) {
                      final selected = selectedTab == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),

                          margin: EdgeInsets.only(right: 10.w),

                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),

                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xffF0FDF4)
                                : Colors.white.withOpacity(0.8),

                            borderRadius: BorderRadius.circular(16.r),

                            border: Border.all(
                              color: selected
                                  ? const Color(0xff22C55E)
                                  : Colors.transparent,
                            ),
                          ),

                          child: Text(
                            deviceTabs[index]['name'],

                            style: TextStyle(
                              color: selected ? Colors.green : Colors.black,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 20.h),

                /// =====================================================
                /// SCHEDULE CARD
                /// =====================================================
                Container(
                  padding: EdgeInsets.all(20.w),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),

                    borderRadius: BorderRadius.circular(28.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),

                        blurRadius: 20,

                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.blue),

                          SizedBox(width: 10.w),

                          Text(
                            "Smart Schedule",

                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// TURN ON
                      _timeCard(
                        title: "Turn ON",

                        time: schedules[currentId]!["on"]!,

                        icon: Icons.lightbulb,

                        color: Colors.green,

                        onTap: () => _pickTime(true),
                      ),

                      SizedBox(height: 14.h),

                      /// TURN OFF
                      _timeCard(
                        title: "Turn OFF",

                        time: schedules[currentId]!["off"]!,

                        icon: Icons.power_settings_new,

                        color: Colors.red,

                        onTap: () => _pickTime(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// TIME CARD
  /// =====================================================
  Widget _timeCard({
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(16.w),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),

          color: color.withOpacity(0.08),
        ),

        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: color.withOpacity(0.2),
              ),

              child: Icon(icon, color: color),
            ),

            SizedBox(width: 14.w),

            Expanded(
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            Text(
              time.format(context),

              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,

                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// MODE BUTTON
  /// =====================================================
  Widget _modeButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: EdgeInsets.symmetric(vertical: 16.h),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),

          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xff22C55E), Color(0xff3B82F6)],
                )
              : null,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: selected ? Colors.white : Colors.black),

            SizedBox(width: 8.w),

            Text(
              title,

              style: TextStyle(
                color: selected ? Colors.white : Colors.black,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// TOP ICON
  /// =====================================================
  Widget _circleIcon(IconData icon) {
    return Container(
      width: 46.w,
      height: 46.w,

      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),

      child: Icon(icon),
    );
  }
}
