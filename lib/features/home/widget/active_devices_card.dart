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

  /// 🔥 DEVICE CONFIG
  static const Map<String, Map<String, dynamic>> deviceConfig = {
    "flexy-001": {
      "title": "Lamp",
      "room": "Living Room",
      "icon": Icons.light_outlined,
      "iconBg": Color(0xffEEF9F0),
      "iconColor": Color(0xff22C55E),
    },
    "flexy-002": {
      "title": "Lamp",
      "room": "Bedroom",
      "icon": Icons.light_outlined,
      "iconBg": Color(0xffEEF4FF),
      "iconColor": Color(0xff3B82F6),
    },
    "flexy-003": {
      "title": "Lamp",
      "room": "Kitchen",
      "icon": Icons.light_outlined,
      "iconBg": Color(0xffEEF4FF),
      "iconColor": Color(0xff3B82F6),
    },
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: deviceService,
      builder: (context, _) {
        /// 🔥 FILTER DEVICE VALID
        final devices = deviceService.getAllDevices().where((d) {
          return deviceConfig.containsKey(d.deviceId);
        }).toList();

        int onlineCount = 0;

        final items = devices.map((d) {
          final config = deviceConfig[d.deviceId]!;

          final device = deviceService.getDevice(d.deviceId);

          /// 🔥 REALTIME STATUS
          final isOn = device?.status['state'] == "ON";

          if (isOn) onlineCount++;

          return _deviceItem(
            deviceId: d.deviceId,
            icon: config['icon'],
            iconBg: config['iconBg'],
            iconColor: config['iconColor'],
            title: config['title'],
            room: config['room'],
            isOn: isOn,
          );
        }).toList();

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
              /// ================= HEADER =================
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

                  /// 🔥 ONLINE COUNT REALTIME
                  Text(
                    "$onlineCount Online",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff22C55E),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Icon(
                    Icons.chevron_right,
                    size: 18.sp,
                    color: const Color(0xff22C55E),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              /// ================= DEVICE LIST =================
              ...items,

              SizedBox(height: 10.h),

              /// ================= FOOTER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View all devices",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff2563EB),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    size: 18.sp,
                    color: const Color(0xff2563EB),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= DEVICE ITEM =================
  Widget _deviceItem({
    required String deviceId,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String room,
    required bool isOn,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xffF1F3F5)),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 24.sp, color: iconColor),
          ),

          SizedBox(width: 14.w),

          /// NAME
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
                  room,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          /// STATUS
          Row(
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xffD1D5DB),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                isOn ? "ON" : "OFF",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isOn
                      ? const Color(0xff22C55E)
                      : const Color(0xff9CA3AF),
                ),
              ),
            ],
          ),

          SizedBox(width: 14.w),

          /// 🔥 SWITCH CONTROL (OPTIMISTIC + MQTT)
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isOn,
              onChanged: (value) {
                final command = value ? "ON" : "OFF";

                /// 🔥 UPDATE UI LANGSUNG (OPTIMISTIC)
                final device = deviceService.getDevice(deviceId);
                if (device != null) {
                  device.status['state'] = command;
                  deviceService.notifyListeners();
                }

                /// 🔥 KIRIM KE MQTT
                mqttService.sendControl(deviceId, "LED", command);

                debugPrint("SEND -> $deviceId : $command");
              },
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
