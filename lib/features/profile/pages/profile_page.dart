import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_home_mobile/core/theme/app_color.dart';
import 'package:smart_home_mobile/features/home/widget/animated_background.dart';
import 'package:smart_home_mobile/features/home/widget/glass_card.dart';
import 'package:smart_home_mobile/features/profile/widget/profile_menu_title.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                /// USER INFO
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 28.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Text(
                      "Rumah Festivale",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                /// THIRD PARTY SERVICES
                GlassCard(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Third-Party Services",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _serviceItem("assets/images/Alexa.png", "Alexa"),
                          _serviceItem(
                            "assets/images/Google.png",
                            "Google Assistant",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// MENU LIST
                GlassCard(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: const [
                      ProfileMenuTile(
                        icon: Icons.home_outlined,
                        title: "Home Management",
                      ),
                      ProfileMenuTile(
                        icon: Icons.message_outlined,
                        title: "Message Center",
                      ),
                      ProfileMenuTile(
                        icon: Icons.help_outline,
                        title: "FAQ & Feedback",
                      ),
                      ProfileMenuTile(
                        icon: Icons.bookmark_border,
                        title: "Featured",
                      ),
                      ProfileMenuTile(
                        icon: Icons.shopping_bag_outlined,
                        title: "App Mall",
                      ),
                      ProfileMenuTile(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceItem(String imagePath, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.5),
          ),
          child: Image.asset(
            imagePath,
            width: 40.w,
            height: 40.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.black87),
        ),
      ],
    );
  }
}
