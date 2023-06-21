import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/NavigationScreens/AppLayout.dart';
import 'package:trial1/Screens/NavigationScreens/welcome.dart';
import 'package:trial1/Screens/OnBoardingScreen.dart';

class SplashScreen extends StatefulWidget {
  String? email, password;

  SplashScreen({super.key, required this.email, required this.password});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Widget secondScreen =  WelcomeScreen();
    if (widget.email != null && widget.password != null) {
      secondScreen = const AppLayout();
    }
    Timer(
        const Duration(seconds: 5),
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
