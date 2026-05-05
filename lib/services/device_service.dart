import 'dart:async';
import 'package:flutter/foundation.dart';
import 'mqtt_service.dart';

class DeviceData {
  final String deviceId;

  Map<String, dynamic> sensors = {};
  Map<String, dynamic> status = {};
  Map<String, dynamic> realtime = {};

  /// 🔥 AKUMULASI BIAYA
  double totalCost = 0;

  DateTime? lastUpdate;

  DeviceData({required this.deviceId});
}

class DeviceDataService extends ChangeNotifier {
  final MqttService mqtt;

  DeviceDataService(this.mqtt) {
    _init();
  }

  final Map<String, DeviceData> _devices = {};
  Map<String, DeviceData> get devices => _devices;

  final Map<String, Map<String, dynamic>> _envPerDevice = {};

  final _envController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get environmentStream => _envController.stream;

  /// 🔥 TARIF
  static const double tarif = 1444;

  void _init() {
    mqtt.onParsedMessage = (topic, data) {
      _handleMessage(topic, data);
    };
  }

  void _handleMessage(String topic, Map<String, dynamic> json) {
    try {
      final deviceId = json['device_id'];
      if (deviceId == null) return;

      bool updated = false;

      _devices.putIfAbsent(deviceId, () => DeviceData(deviceId: deviceId));
      final device = _devices[deviceId]!;

      _envPerDevice.putIfAbsent(deviceId, () => {});
      final env = _envPerDevice[deviceId]!;

      /// ================= SENSOR =================
      if (topic.contains('sensor')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          device.sensors.addAll(data);

          if (data.containsKey('tempC')) {
            env['temperature'] = data['tempC'];
            updated = true;
          }

          if (data.containsKey('humidity')) {
            env['humidity'] = data['humidity'];
            updated = true;
          }

          if (data.containsKey('motion')) {
            env['motion'] = data['motion'] == 1;
            updated = true;
          }
        }
      }

      /// ================= LDR =================
      if (topic.contains('ldr')) {
        if (json.containsKey('data')) {
          final data = json['data'];
          if (data.containsKey('state')) {
            env['light'] = data['state'];
            updated = true;
          }
        }
      }

      /// ================= FAN =================
      if (topic.contains('fan')) {
        if (json.containsKey('status')) {
          env['fan'] = json['status'];
          updated = true;
        }
      }

      /// ================= LED STATUS =================
      if (topic.contains('status/led')) {
        if (json.containsKey('status')) {
          device.status['state'] = json['status'];
        }
      }

      /// ================= 🔥 REALTIME PZEM =================
      /// ================= 🔥 REALTIME PZEM =================
      if (topic.contains('realtime/pzem')) {
        if (json.containsKey('data')) {
          final data = json['data'];

          /// 🔥 AMBIL DATA DARI SENSOR
          final power = (data['power'] ?? 0).toDouble();
          final energy = (data['energy'] ?? 0).toDouble();

          /// 🔥 TARIF LISTRIK
          const double tarif = 1444;

          /// ===============================
          /// 🔥 SAVE RAW DATA
          /// ===============================
          device.realtime.addAll(data);

          /// ===============================
          /// 🔥 MAP KE ENV (UNTUK UI)
          /// ===============================
          env['power'] = power;
          env['voltage'] = (data['voltage'] ?? 0).toDouble();
          env['current'] = (data['current'] ?? 0).toDouble();

          /// 🔥 ENERGY (LANGSUNG DARI PZEM)
          env['energy'] = energy;

          /// 🔥 COST (AKURAT & STABIL)
          env['cost'] = energy * tarif;

          /// ===============================
          /// 🔥 STREAM KE UI
          /// ===============================
          _envController.add({'device_id': deviceId, 'data': Map.from(env)});
        }
      }

      if (updated) {
        _envController.add({'device_id': deviceId, 'data': Map.from(env)});
      }

      notifyListeners();
    } catch (e) {
      print("DeviceDataService error: $e");
    }
  }

  DeviceData? getDevice(String id) => _devices[id];

  List<DeviceData> getAllDevices() => _devices.values.toList();

  Map<String, dynamic> getEnv(String deviceId) {
    return _envPerDevice[deviceId] ?? {};
  }

  void disposeService() {
    _envController.close();
  }
}
