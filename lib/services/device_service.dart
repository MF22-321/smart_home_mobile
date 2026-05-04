import 'dart:async';
import 'package:flutter/foundation.dart';
import 'mqtt_service.dart';

/// ===============================
/// MODEL DEVICE
/// ===============================
class DeviceData {
  final String deviceId;

  Map<String, dynamic> sensors = {};
  Map<String, dynamic> status = {};
  Map<String, dynamic> realtime = {};

  DeviceData({required this.deviceId});
}

/// ===============================
/// DEVICE SERVICE (FINAL)
/// ===============================
class DeviceDataService extends ChangeNotifier {
  final MqttService mqtt;

  DeviceDataService(this.mqtt) {
    _init();
  }

  /// ===============================
  /// STORAGE
  /// ===============================
  final Map<String, DeviceData> _devices = {};
  Map<String, DeviceData> get devices => _devices;

  /// 🔥 ENV PER DEVICE (ANTI TABRAKAN)
  final Map<String, Map<String, dynamic>> _envPerDevice = {};

  /// ===============================
  /// STREAM (REALTIME UI)
  /// ===============================
  final _envController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get environmentStream => _envController.stream;

  /// ===============================
  /// INIT MQTT LISTENER
  /// ===============================
  void _init() {
    mqtt.onParsedMessage = (topic, data) {
      _handleMessage(topic, data);
    };
  }

  /// ===============================
  /// HANDLE MQTT MESSAGE
  /// ===============================
  void _handleMessage(String topic, Map<String, dynamic> json) {
    try {
      final deviceId = json['device_id'];
      if (deviceId == null) return;

      bool updated = false;

      /// ===============================
      /// INIT DEVICE
      /// ===============================
      _devices.putIfAbsent(deviceId, () => DeviceData(deviceId: deviceId));

      final device = _devices[deviceId]!;

      /// INIT ENV DEVICE
      _envPerDevice.putIfAbsent(deviceId, () => {});
      final env = _envPerDevice[deviceId]!;

      /// ===============================
      /// SENSOR DATA
      /// ===============================
      if (topic.contains('sensor')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          device.sensors.addAll(data);

          /// 🌡️ TEMPERATURE
          if (data.containsKey('tempC')) {
            env['temperature'] = data['tempC'];
            updated = true;
          }

          /// 💧 HUMIDITY
          if (data.containsKey('humidity')) {
            env['humidity'] = data['humidity'];
            updated = true;
          }

          /// 🚶 PIR
          if (data.containsKey('motion')) {
            env['motion'] = data['motion'] == 1;
            updated = true;
          }
        }
      }

      /// ===============================
      /// LDR (OPTIONAL DEVICE)
      /// ===============================
      if (topic.contains('ldr')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          if (data.containsKey('state')) {
            env['light'] = data['state']; // DARK / BRIGHT
            updated = true;
          }
        }
      }

      /// ===============================
      /// FAN STATUS 🔥 (FLEXY-004)
      /// ===============================
      if (topic.contains('fan')) {
        if (json.containsKey('status')) {
          env['fan'] = json['status']; // ON / OFF
          updated = true;
        }
      }

      /// ===============================
      /// DEVICE STATUS (GENERAL)
      /// ===============================
      if (topic.contains('status')) {
        if (json.containsKey('status')) {
          device.status['state'] = json['status'];
        }
      }

      /// ===============================
      /// REALTIME (PZEM dll)
      /// ===============================
      if (topic.contains('realtime')) {
        if (json.containsKey('data')) {
          device.realtime.addAll(json['data']);
        }
      }

      /// ===============================
      /// EMIT KE UI
      /// ===============================
      if (updated) {
        _envController.add({'device_id': deviceId, 'data': Map.from(env)});
      }

      notifyListeners();
    } catch (e) {
      print("DeviceDataService error: $e");
    }
  }

  /// ===============================
  /// GET DEVICE
  /// ===============================
  DeviceData? getDevice(String id) => _devices[id];

  /// ===============================
  /// GET ALL DEVICES
  /// ===============================
  List<DeviceData> getAllDevices() => _devices.values.toList();

  /// ===============================
  /// GET ENV BY DEVICE (OPTIONAL)
  /// ===============================
  Map<String, dynamic> getEnv(String deviceId) {
    return _envPerDevice[deviceId] ?? {};
  }

  /// ===============================
  /// DISPOSE
  /// ===============================
  void disposeService() {
    _envController.close();
  }
}
