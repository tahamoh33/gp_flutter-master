import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/helpers/cache_manager.dart';
import 'package:trial1/helpers/firebase_api.dart';
import 'package:trial1/theme/dark_theme.dart';
import 'package:trial1/theme/light_theme.dart';

import 'Screens/SplashScreen.dart';
import 'Screens/State Management/selected_page_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await firebaseApi().initNotification();
  await CacheManager.init();
  // await Notification().initNotification();
  String? email, password, role;

  if (CacheManager.getData('email') != null) {
    email = await CacheManager.getData('email');
    password = await CacheManager.getData('password');
    role = await CacheManager.getData('role');
  }
  // runApp(
  //   DevicePreview(
  //       enabled: !kReleaseMode,
  //       builder: (context) => ChangeNotifierProvider<SelectedPageProvider>(
  //             create: (context) => SelectedPageProvider(),
  //             child: myApp(
  //                 email: email,
  //                 password: password,
  //                 role: role), // Wrap your app
  //           )),
  // );
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
