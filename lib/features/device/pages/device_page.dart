import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/services/device_service.dart';
import 'package:smart_home_mobile/services/mqtt_service.dart';

class DevicePage extends StatefulWidget {
  final MqttService mqttService;
  final DeviceDataService deviceService;

  const DevicePage({
    super.key,
    required this.mqttService,
    required this.deviceService,
  });

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  int selectedCategory = 0;

  /// =====================================================
  /// 🔥 DEVICE LIST
  /// =====================================================
  final List<Map<String, dynamic>> deviceList = [
    {
      "title": "Living Room Lamp",
      "device_id": "flexy-001",
      "target": "LED",
      "statusKey": "led",
      "room": "living",
      "icon": Icons.lightbulb,
      "color": Color(0xffFACC15),
    },

    {
      "title": "Bedroom Lamp",
      "device_id": "flexy-002",
      "target": "LED",
      "statusKey": "led",
      "room": "bedroom",
      "icon": Icons.lightbulb,
      "color": Color(0xff60A5FA),
    },

    {
      "title": "Kitchen Lamp",
      "device_id": "flexy-003",
      "target": "LED",
      "statusKey": "led",
      "room": "kitchen",
      "icon": Icons.lightbulb,
      "color": Color(0xff34D399),
    },

    /// 🔥 FLEXY-004 LED
    {
      "title": "Outdoor Front Lamp",
      "device_id": "flexy-004",
      "target": "LED",
      "statusKey": "led",
      "room": "outdoor",
      "icon": Icons.lightbulb,
      "color": Color(0xffF59E0B),
    },

    /// 🔥 FLEXY-004 FAN
    {
      "title": "Outdoor Cooling Fan",
      "device_id": "flexy-004",
      "target": "FAN",
      "statusKey": "fan",
      "room": "outdoor",
      "icon": Icons.mode_fan_off_outlined,
      "color": Color(0xff3B82F6),
    },

    /// 🔥 FLEXY-005
    {
      "title": "Outdoor Backyard Lamp",
      "device_id": "flexy-005",
      "target": "LED",
      "statusKey": "led",
      "room": "outdoor",
      "icon": Icons.lightbulb,
      "color": Color(0xff22C55E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),

              _header(),

              SizedBox(height: 20.h),

              _category(),

              SizedBox(height: 20.h),

              /// =====================================================
              /// DEVICE LIST
              /// =====================================================
              Expanded(
                child: AnimatedBuilder(
                  animation: widget.deviceService,
                  builder: (context, _) {
                    final devices = widget.deviceService.devices;

                    final filtered = deviceList.where((d) {
                      if (selectedCategory == 0) return true;
                      if (selectedCategory == 1) {
                        return d['room'] == "living";
                      }
                      if (selectedCategory == 2) {
                        return d['room'] == "bedroom";
                      }
                      if (selectedCategory == 3) {
                        return d['room'] == "kitchen";
                      }
                      if (selectedCategory == 4) {
                        return d['room'] == "outdoor";
                      }

                      return true;
                    }).toList();

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];

                        final deviceId = item['device_id'];
                        final statusKey = item['statusKey'];

                        final device = devices[deviceId];

                        final isOn = device?.status[statusKey] == "ON";

                        final motion = device?.sensors['motion'] == 1;

                        return _deviceCard(
                          title: item['title'],
                          icon: item['icon'],
                          color: item['color'],
                          isOn: isOn,
                          motion: motion,
                          deviceId: deviceId,
                          target: item['target'],
                          statusKey: statusKey,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// HEADER
  /// =====================================================
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _topIcon(Icons.menu),

        Text(
          "FlexySave",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
        ),

        _topIcon(Icons.notifications_none),
      ],
    );
  }

  /// =====================================================
  /// CATEGORY
  /// =====================================================
  Widget _category() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip("All", 0),
          _chip("Living", 1),
          _chip("Bedroom", 2),
          _chip("Kitchen", 3),
          _chip("Outdoor", 4),
        ],
      ),
    );
  }

  Widget _chip(String text, int index) {
    final selected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),

        decoration: BoxDecoration(
          color: selected ? const Color(0xffF0FDF4) : Colors.white,

          borderRadius: BorderRadius.circular(14.r),
        ),

        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.green : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// DEVICE CARD
  /// =====================================================
  Widget _deviceCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isOn,
    required bool motion,
    required String deviceId,
    required String target,
    required String statusKey,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 120.h,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),

        border: Border.all(
          color: isOn ? color.withOpacity(0.25) : Colors.transparent,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          /// =====================================================
          /// ICON
          /// =====================================================
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 64.w,
            height: 64.w,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: isOn ? color.withOpacity(0.18) : const Color(0xffF3F4F6),

              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),

            child: Icon(
              icon,
              size: 34.sp,
              color: isOn ? color : const Color(0xff9CA3AF),
            ),
          ),

          SizedBox(width: 18.w),

          /// =====================================================
          /// INFO
          /// =====================================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 6.h),

                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,

                      decoration: BoxDecoration(
                        color: motion ? Colors.red : Colors.grey,

                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      motion ? "Motion Detected" : "No Motion",

                      style: TextStyle(
                        color: motion ? Colors.red : Colors.grey,

                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// =====================================================
          /// SWITCH
          /// =====================================================
          Transform.scale(
            scale: 1.0,

            child: Opacity(
              /// 🔥 AUTO MODE VISUAL
              opacity: widget.deviceService.isAutomationMode ? 0.55 : 1,

              child: IgnorePointer(
                /// 🔥 LOCK SWITCH
                ignoring: widget.deviceService.isAutomationMode,

                child: Switch(
                  value: isOn,

                  onChanged: (val) {
                    final command = val ? "ON" : "OFF";

                    /// 🔥 SEND MQTT
                    widget.mqttService.sendControl(deviceId, target, command);

                    /// 🔥 OPTIMISTIC UI
                    final device = widget.deviceService.getDevice(deviceId);

                    if (device != null) {
                      device.status[statusKey] = command;
                    }

                    widget.deviceService.notifyListeners();

                    debugPrint("SEND -> $deviceId | $target | $command");
                  },

                  activeColor: Colors.white,

                  activeTrackColor: const Color(0xff22C55E),

                  inactiveThumbColor: Colors.white,

                  inactiveTrackColor: const Color(0xffD1D5DB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topIcon(IconData icon) {
    return Container(
      width: 50.w,
      height: 50.w,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Icon(icon),
    );
  }
}
