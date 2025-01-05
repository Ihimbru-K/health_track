import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_track/features/onboarding/onboarding_ui.dart';

import 'features/dashboard/dashboard_ui.dart';
import 'features/homescreen/homescreen.dart';
import 'features/journaling/journaling_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ///responsiveness for all device sizes
      designSize: Size(360, 690),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Journal App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: OnboardingScreen(),
      ),
    );
  }
}























