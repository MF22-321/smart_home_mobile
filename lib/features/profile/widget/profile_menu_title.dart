import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileMenuTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20.sp, color: Colors.black87),
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      ),
      trailing: Icon(Icons.chevron_right, size: 18.sp),
    );
  }
}
