import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/SplashScreen.dart';
import 'package:trial1/Screens/State%20Management/selected_page_provider.dart';
import 'package:trial1/Screens/cache_manager.dart';
import 'package:trial1/theme/dark_theme.dart';
import 'package:trial1/theme/light_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheManager.init();
  String? email, password, role;

  if (CacheManager.getData('email') != null) {
    email = await CacheManager.getData('email');
    password = await CacheManager.getData('password');
    role = await CacheManager.getData('role');
  }
  runApp(
    ChangeNotifierProvider<SelectedPageProvider>(
      create: (_) => SelectedPageProvider(),
      child: myApp(email: email, password: password, role: role),
    ),
  );
}

class myApp extends StatelessWidget {
  String? email, password, role;

  myApp(
      {super.key,
      required this.email,
      required this.password,
      required this.role});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: SplashScreen(email: email, password: password, role: role),
        );
      }, //SplashScreen(email: email, password: password)
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
