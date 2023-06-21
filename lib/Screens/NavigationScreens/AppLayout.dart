import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trial1/Screens/NavigationScreens/DetectionScreen.dart';
import 'package:trial1/Screens/NavigationScreens/History.dart';
import 'package:trial1/Screens/NavigationScreens/Home.dart';
import 'package:trial1/Screens/NavigationScreens/show_profile.dart';

import '../State Management/selected_page_provider.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> {
  List Screens = [const HomeScreen(),const History(), DetectionScreen(),const showProfile()];

  @override
  Widget build(BuildContext context) {
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Screens[selectedPageProvider.selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'Check Eyes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedPageProvider.selectedIndex,
        selectedItemColor: const Color(0xff1a74d7),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          selectedPageProvider.selectedIndex = index;
        },
      ),
    );
  }
}
