import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/Doctor/doctor_app_layout.dart';
import 'package:trial1/Screens/NavigationScreens/AppLayout.dart';
import 'package:trial1/Screens/NavigationScreens/welcome.dart';

class SplashScreen extends StatefulWidget {
  String? email, password, role;

  SplashScreen(
      {super.key,
      required this.email,
      required this.password,
      required this.role});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Widget secondScreen = WelcomeScreen();
    if (widget.email != null && widget.password != null) {
      if (widget.role == 'Patient') {
        secondScreen = const AppLayout();
      } else if (widget.role == 'Doctor') {
        secondScreen = const DoctorLayout();
      }
    }
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => secondScreen)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('lib/images/logo.png', width: 50.w),
      ),
    );
  }
}
