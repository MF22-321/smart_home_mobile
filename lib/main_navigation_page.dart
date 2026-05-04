import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/analytics/analytics_page.dart';
import 'package:smart_home_mobile/features/automation/pages/automation_pages.dart';
import 'package:smart_home_mobile/features/device/pages/device_page.dart';
import 'package:smart_home_mobile/features/environtment/environtment_page.dart';
import 'package:smart_home_mobile/features/home/page/home_page.dart';
import 'package:smart_home_mobile/features/home/widget/bottom_navbar.dart';
import 'package:smart_home_mobile/services/device_service.dart';
import 'package:smart_home_mobile/services/mqtt_service.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 0;

  final MqttService _mqttService = MqttService();
  late DeviceDataService _deviceService;

  bool _isMqttConnected = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    /// 🔥 INIT SERVICE DULU
    _deviceService = DeviceDataService(_mqttService);

    /// 🔥 CONNECT MQTT
    await _mqttService.connect('mobile-app');

    /// 🔥 STATUS
    _mqttService.onConnectionStatusChange = (status) {
      setState(() {
        _isMqttConnected = status;
      });
    };

    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _deviceService.disposeService();
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      HomePage(
        mqttService: _mqttService,
        mqttConnectionStatus: _isMqttConnected,
      ),
      DevicePage(mqttService: _mqttService, deviceService: _deviceService),
      const AnalyticsPage(),
      AutomationPage(mqttService: _mqttService),
      EnvironmentPage(deviceService: _deviceService),
    ];

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 10.h,
            top: 8.h,
          ),
          child: BottomNavbar(
            selectedIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
