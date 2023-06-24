import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/Doctor/DoctorScreen.dart';
import 'package:trial1/Screens/SplashScreen.dart';
import 'package:trial1/Screens/State%20Management/selected_page_provider.dart';
import 'package:trial1/Screens/cache_manager.dart';
import 'package:trial1/theme/dark_theme.dart';
import 'package:trial1/theme/light_theme.dart';

import 'Screens/State Management/dark_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheManager.init();
  String? email, password;

  if (CacheManager.getData('email') != null) {
    email = await CacheManager.getData('email');
    password = await CacheManager.getData('password');
  }
  runApp(
    ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) => DarkThemeProvider(),
      child: ChangeNotifierProvider<SelectedPageProvider>(
        create: (_) => SelectedPageProvider(),
        child: myApp(email: email, password: password),
      ),
    ),
  );
}

class myApp extends StatelessWidget {
  String? email, password;

  myApp({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          home:SplashScreen(email: email, password: password) ,
        );
      },//SplashScreen(email: email, password: password)
    );
  }
}

// ThemeData _buildLightTheme() {
//   return ThemeData.light().copyWith(
//     // Customize light mode colors here...
//     primaryColor: Colors.blue,
//     accentColor: Colors.green,
//     // Add more color customizations...
//   );
// }
//
// ThemeData _buildDarkTheme() {
//   return ThemeData.dark().copyWith(
//     // Customize dark mode colors here...
//     primaryColor: Colors.deepPurple,
//     accentColor: Colors.teal,
//     // Add more color customizations...
//   );
// }
