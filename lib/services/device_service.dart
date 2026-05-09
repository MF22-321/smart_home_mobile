import 'dart:async';
import 'package:flutter/foundation.dart';
import 'mqtt_service.dart';

/// =====================================================
/// DEVICE MODEL
/// =====================================================
class DeviceData {
  final String deviceId;

  /// SENSOR DATA
  Map<String, dynamic> sensors = {};

  /// STATUS DEVICE
  /// ex:
  /// led  -> ON/OFF
  /// fan  -> ON/OFF
  Map<String, dynamic> status = {};

  /// REALTIME DATA
  Map<String, dynamic> realtime = {};

  /// 🔥 TOTAL COST
  double totalCost = 0;

  DateTime? lastUpdate;

  DeviceData({required this.deviceId});
}

/// =====================================================
/// DEVICE DATA SERVICE
/// =====================================================
class DeviceDataService extends ChangeNotifier {
  final MqttService mqtt;

  DeviceDataService(this.mqtt) {
    _init();
  }

  /// =====================================================
  /// STORAGE
  /// =====================================================
  final Map<String, DeviceData> _devices = {};

  Map<String, DeviceData> get devices => _devices;

  /// =====================================================
  /// ENV STORAGE
  /// =====================================================
  final Map<String, Map<String, dynamic>> _envPerDevice = {};

  /// =====================================================
  /// STREAM REALTIME
  /// =====================================================
  final _envController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get environmentStream => _envController.stream;

  /// =====================================================
  /// TARIF PLN
  /// =====================================================
  static const double tarif = 1444;

  bool isAutomationMode = true;

  /// =====================================================
  /// INIT MQTT
  /// =====================================================
  void _init() {
    mqtt.onParsedMessage = (topic, data) {
      _handleMessage(topic, data);
    };
  }

  /// =====================================================
  /// HANDLE MQTT
  /// =====================================================
  void _handleMessage(String topic, Map<String, dynamic> json) {
    try {
      final deviceId = json['device_id'];

      if (deviceId == null) return;

      bool updated = false;

      /// =====================================================
      /// INIT DEVICE
      /// =====================================================
      _devices.putIfAbsent(deviceId, () => DeviceData(deviceId: deviceId));

      final device = _devices[deviceId]!;

      /// =====================================================
      /// INIT ENV
      /// =====================================================
      _envPerDevice.putIfAbsent(deviceId, () => {});

      final env = _envPerDevice[deviceId]!;

      /// =====================================================
      /// SENSOR DATA
      /// =====================================================
      if (topic.contains('sensor')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          device.sensors.addAll(data);

          /// TEMP
          if (data.containsKey('tempC')) {
            env['temperature'] = data['tempC'];
            updated = true;
          }

          /// HUMIDITY
          if (data.containsKey('humidity')) {
            env['humidity'] = data['humidity'];
            updated = true;
          }

          /// MOTION
          if (data.containsKey('motion')) {
            env['motion'] = data['motion'] == 1;
            updated = true;
          }
        }
      }

      /// =====================================================
      /// LDR
      /// =====================================================
      if (topic.contains('sensor/ldr')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          if (data.containsKey('state')) {
            env['light'] = data['state'];
            updated = true;
          }
        }
      }

      /// =====================================================
      /// LED STATUS
      /// =====================================================
      if (topic.contains('status/led')) {
        if (json.containsKey('status')) {
          device.status['led'] = json['status'];

          /// 🔥 REALTIME UI
          _envController.add({'device_id': deviceId, 'data': Map.from(env)});

          notifyListeners();
        }
      }

      /// =====================================================
      /// FAN STATUS
      /// =====================================================
      if (topic.contains('status/fan')) {
        if (json.containsKey('status')) {
          device.status['fan'] = json['status'];

          /// 🔥 REALTIME UI
          _envController.add({'device_id': deviceId, 'data': Map.from(env)});

          notifyListeners();
        }
      }

      /// =====================================================
      /// SYSTEM STATUS
      /// =====================================================
      if (topic.contains('status/system')) {
        if (json.containsKey('status')) {
          final mode = json['status'];

          /// 🔥 AUTO / MANUAL
          isAutomationMode = mode == "AUTO";

          notifyListeners();
        }
      }

      /// =====================================================
      /// REALTIME PZEM
      /// =====================================================
      if (topic.contains('realtime/pzem')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          /// 🔥 SENSOR VALUE
          final power = (data['power'] ?? 0).toDouble();

          final energy = (data['energy'] ?? 0).toDouble();

          /// =====================================================
          /// SAVE RAW
          /// =====================================================
          device.realtime.addAll(data);

          /// =====================================================
          /// MAP KE ENV
          /// =====================================================
          env['power'] = power;

          env['voltage'] = (data['voltage'] ?? 0).toDouble();

          env['current'] = (data['current'] ?? 0).toDouble();

          /// 🔥 ENERGY REAL DARI PZEM
          env['energy'] = energy;

          /// 🔥 COST
          env['cost'] = energy * tarif;

          /// =====================================================
          /// STREAM
          /// =====================================================
          _envController.add({'device_id': deviceId, 'data': Map.from(env)});

          notifyListeners();
        }
      }

      /// =====================================================
      /// UPDATE STREAM
      /// =====================================================
      if (updated) {
        _envController.add({'device_id': deviceId, 'data': Map.from(env)});
      }

      notifyListeners();
    } catch (e) {
      debugPrint("DeviceDataService error: $e");
    }
  }

  /// =====================================================
  /// GET DEVICE
  /// =====================================================
  DeviceData? getDevice(String id) {
    return _devices[id];
  }

  /// =====================================================
  /// GET ALL DEVICES
  /// =====================================================
  List<DeviceData> getAllDevices() {
    return _devices.values.toList();
  }

  /// =====================================================
  /// GET ENV
  /// =====================================================
  Map<String, dynamic> getEnv(String deviceId) {
    return _envPerDevice[deviceId] ?? {};
  }

  /// =====================================================
  /// DISPOSE
  /// =====================================================
  void disposeService() {
    _envController.close();
  }
}
