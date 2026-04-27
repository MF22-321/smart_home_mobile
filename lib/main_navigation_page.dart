import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/features/analytics/analytics_page.dart';
import 'package:smart_home_mobile/features/automation/pages/automation_pages.dart';
import 'package:smart_home_mobile/features/device/pages/device_page.dart';
import 'package:smart_home_mobile/features/environtment/environtment_page.dart';
import 'package:smart_home_mobile/features/home/page/home_page.dart';
import 'package:smart_home_mobile/features/home/widget/bottom_navbar.dart';
import 'package:smart_home_mobile/features/profile/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    DevicePage(),
    AnalyticsPage(),
    AutomationPage(),
    EnvironmentPage(),
  ];

  @override
  Widget build(BuildContext context) {
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
