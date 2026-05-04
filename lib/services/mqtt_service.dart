import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;

  final String _host = '43.157.213.11';
  final int _port = 1883;
  final String _username = 'flexyadmin';
  final String _password = 'FlexySave!20403';

  String _clientId = '';
  bool _isConnecting = false;
  bool _isListening = false;

  Function(bool)? _onConnectionStatusChange;
  Function(String, Map<String, dynamic>)? _onParsedMessage;

  set onConnectionStatusChange(Function(bool)? cb) =>
      _onConnectionStatusChange = cb;

  set onParsedMessage(Function(String, Map<String, dynamic>)? cb) =>
      _onParsedMessage = cb;

  /// ===============================
  /// CONNECT MQTT
  /// ===============================
  Future<bool> connect(String deviceId) async {
    if (_isConnecting) return false;
    _isConnecting = true;

    _clientId = 'flutter_$deviceId';

    _client = MqttServerClient(_host, _clientId)
      ..port = _port
      ..keepAlivePeriod = 20
      ..autoReconnect = true
      ..logging(on: false);

    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;

    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .authenticateAs(_username, _password);

    try {
      print("🔌 Connecting to MQTT...");
      await _client!.connect();

      if (_client!.connectionState != MqttConnectionState.connected) {
        print("❌ MQTT failed to connect");
        _client!.disconnect();
        _isConnecting = false;
        return false;
      }

      _isConnecting = false;
      return true;
    } catch (e) {
      print('❌ MQTT error: $e');
      _client?.disconnect();
      _isConnecting = false;
      return false;
    }
  }

  /// ===============================
  /// LISTENER MQTT
  /// ===============================
  void _listen() {
    if (_client?.updates == null || _isListening) return;
    _isListening = true;

    _client!.updates!.listen((events) {
      if (events.isEmpty) return;

      final recMess = events.first;
      final topic = recMess.topic;

      final msg = recMess.payload as MqttPublishMessage;

      final payload = MqttPublishPayload.bytesToStringAsString(
        msg.payload.message,
      );

      print("📩 [$topic] $payload");

      if (payload.isEmpty) return;

      try {
        final jsonData = jsonDecode(payload);

        if (jsonData is Map<String, dynamic>) {
          _onParsedMessage?.call(topic, jsonData);
        }
      } catch (e) {
        print("❌ JSON error: $e");
      }
    });
  }

  /// ===============================
  /// ON CONNECTED
  /// ===============================
  void _onConnected() {
    print('✅ MQTT Connected');

    _client!.subscribe('flexysave/sensor/#', MqttQos.atLeastOnce);
    _client!.subscribe('flexysave/status/#', MqttQos.atLeastOnce);
    _client!.subscribe('flexysave/realtime/#', MqttQos.atLeastOnce);

    _listen(); // 🔥 penting di sini

    _onConnectionStatusChange?.call(true);
  }

  /// ===============================
  /// ON DISCONNECTED
  /// ===============================
  void _onDisconnected() {
    print('❌ MQTT Disconnected');

    _isListening = false; // 🔥 reset listener biar reconnect aman

    _onConnectionStatusChange?.call(false);
  }

  /// ===============================
  /// SEND CONTROL KE ESP
  /// ===============================
  void sendControl(String deviceId, String target, String command) {
    final payload = {
      "device_id": deviceId,
      "target": target.toUpperCase(), // 🔥 WAJIB (ESP case sensitive)
      "command": command.toUpperCase(), // 🔥 WAJIB
    };

    publish('flexysave/control', jsonEncode(payload));
  }

  /// ===============================
  /// PUBLISH MESSAGE
  /// ===============================
  void publish(String topic, String message) {
    if (_client?.connectionState != MqttConnectionState.connected) {
      print("⚠️ MQTT not connected, cannot publish");
      return;
    }

    final builder = MqttClientPayloadBuilder()..addString(message);

    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    print("📤 [$topic] $message");
  }

  /// ===============================
  /// CHECK CONNECTION
  /// ===============================
  bool isConnected() =>
      _client?.connectionState == MqttConnectionState.connected;

  /// ===============================
  /// DISCONNECT
  /// ===============================
  void disconnect() {
    print("🔌 Disconnect MQTT");
    _client?.disconnect();
    _client = null;
    _isListening = false;
  }
}
