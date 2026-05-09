import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/services/device_service.dart';
import 'package:smart_home_mobile/services/mqtt_service.dart';

class ActiveDevicesCard extends StatelessWidget {
  final DeviceDataService deviceService;
  final MqttService mqttService;

  const ActiveDevicesCard({
    super.key,
    required this.deviceService,
    required this.mqttService,
  });

  /// =====================================================
  /// 🔥 DEVICE CONFIG (MULTI DEVICE PER ESP32)
  /// =====================================================
  static const Map<String, List<Map<String, dynamic>>> deviceConfig = {
    "flexy-001": [
      {
        "target": "LED",
        "statusKey": "led",
        "title": "Room 1 Lamp",
        "room": "01",
        "icon": Icons.light_outlined,
        "iconBg": Color(0xffEEF9F0),
        "iconColor": Color(0xff22C55E),
      },
    ],

    "flexy-002": [
      {
        "target": "LED",
        "statusKey": "led",
        "title": "Room 2 Lamp",
        "room": "02",
        "icon": Icons.light_outlined,
        "iconBg": Color(0xffEEF4FF),
        "iconColor": Color(0xff3B82F6),
      },
    ],

    "flexy-003": [
      {
        "target": "LED",
        "statusKey": "led",
        "title": "Room 3 Lamp",
        "room": "03",
        "icon": Icons.light_outlined,
        "iconBg": Color(0xffEEF4FF),
        "iconColor": Color(0xff3B82F6),
      },
    ],

    /// 🔥 FLEXy-004
    "flexy-004": [
      {
        "target": "LED",
        "statusKey": "led",
        "title": "Room 4 Lamp",
        "room": "04",
        "icon": Icons.light_outlined,
        "iconBg": Color(0xffFEF3C7),
        "iconColor": Color(0xffF59E0B),
      },

      {
        "target": "FAN",
        "statusKey": "fan",
        "title": "Room 4 Fan",
        "room": "Outdoor Front",
        "icon": Icons.mode_fan_off_outlined,
        "iconBg": Color(0xffDBEAFE),
        "iconColor": Color(0xff2563EB),
      },
    ],

    /// 🔥 FLEXy-005
    "flexy-005": [
      {
        "target": "LED",
        "statusKey": "led",
        "title": "Lamp",
        "room": "Outdoor Backyard",
        "icon": Icons.light_outlined,
        "iconBg": Color(0xffDCFCE7),
        "iconColor": Color(0xff16A34A),
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: deviceService.environmentStream,
      builder: (context, snapshot) {
        int onlineCount = 0;

        final List<Widget> items = [];

        /// =====================================================
        /// 🔥 GENERATE ALL DEVICES
        /// =====================================================
        deviceConfig.forEach((deviceId, configs) {
          final device = deviceService.getDevice(deviceId);

          for (final config in configs) {
            final statusKey = config['statusKey'];

            final isOn = device?.status[statusKey] == "ON";

            if (isOn) onlineCount++;

            items.add(
              _deviceItem(
                deviceId: deviceId,
                target: config['target'],
                icon: config['icon'],
                iconBg: config['iconBg'],
                iconColor: config['iconColor'],
                title: config['title'],
                room: config['room'],
                isOn: isOn,
              ),
            );
          }
        });

        return Container(
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
              /// =====================================================
              /// HEADER
              /// =====================================================
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
                      Icons.power_outlined,
                      size: 22.sp,
                      color: const Color(0xff3B82F6),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Text(
                      "Active Devices",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff111827),
                      ),
                    ),
                  ),

                  Text(
                    "$onlineCount Online",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff22C55E),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              /// =====================================================
              /// DEVICE LIST
              /// =====================================================
              ...items,
            ],
          ),
        );
      },
    );
  }

  /// =====================================================
  /// 🔥 DEVICE ITEM
  /// =====================================================
  Widget _deviceItem({
    required String deviceId,
    required String target,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String room,
    required bool isOn,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isOn
              ? const Color(0xff22C55E).withOpacity(0.25)
              : const Color(0xffF1F3F5),
        ),
      ),

      child: Row(
        children: [
          /// =====================================================
          /// ICON
          /// =====================================================
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),

            child: Icon(icon, size: 24.sp, color: iconColor),
          ),

          SizedBox(width: 14.w),

          /// =====================================================
          /// TITLE
          /// =====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff111827),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  room,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          /// =====================================================
          /// STATUS
          /// =====================================================
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xffD1D5DB),
                ),
              ),

              SizedBox(width: 8.w),

              Text(
                isOn ? "ON" : "OFF",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xff9CA3AF),
                ),
              ),
            ],
          ),

          SizedBox(width: 14.w),

          /// =====================================================
          /// SWITCH
          /// =====================================================
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isOn,

              /// =====================================================
              /// 🔥 AUTO MODE LOCK
              /// =====================================================
              onChanged: deviceService.isAutomationMode
                  ? null
                  : (value) {
                      final command = value ? "ON" : "OFF";

                      /// 🔥 SEND MQTT
                      mqttService.sendControl(deviceId, target, command);

                      /// 🔥 OPTIMISTIC UI
                      final device = deviceService.getDevice(deviceId);

                      if (device != null) {
                        if (target == "LED") {
                          device.status['led'] = command;
                        }

                        if (target == "FAN") {
                          device.status['fan'] = command;
                        }

                        deviceService.notifyListeners();
                      }

                      debugPrint("SEND -> $deviceId | $target | $command");
                    },

              /// =====================================================
              /// COLORS
              /// =====================================================
              activeColor: Colors.white,

              activeTrackColor: const Color(0xff22C55E),

              inactiveThumbColor: Colors.white,

              inactiveTrackColor: const Color(0xffC7CDD8),
            ),
          ),
        ],
      ),
    );
  }
}
