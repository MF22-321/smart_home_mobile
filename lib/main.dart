import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/main_navigation_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // base design iPhone modern
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,

      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Smart Home',

          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF8FAFC),
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),

          builder: (context, widget) {
            /// prevent system text scaling terlalu besar
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },

          home: const MainNavigationPage(),
        );
      },
    );
  }
}
