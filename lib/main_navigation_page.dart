import 'package:flutter/material.dart';
import 'package:smart_home_mobile/features/automation/pages/automation_pages.dart';
import 'package:smart_home_mobile/features/device/pages/device_page.dart';
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
    AutomationPage(),
    DevicePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 🔥 penting
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
