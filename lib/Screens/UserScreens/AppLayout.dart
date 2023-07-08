import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../State Management/selected_page_provider.dart';
import 'DetectionScreen.dart';
import 'History.dart';
import 'Home.dart';
import 'Profile.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> {
  List Screens = [
    const HomeScreen(),
    const History(),
    const DetectionScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedPageProvider =
          Provider.of<SelectedPageProvider>(context, listen: false);
      selectedPageProvider.selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);
    final bool dark;
    if (Brightness.dark == MediaQuery.of(context).platformBrightness) {
      dark = true;
    } else {
      dark = false;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Screens[selectedPageProvider.selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: dark
            ? const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x1a000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 5)
              ], color: Color(0xff2f2b34))
            : const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x05000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 5)
              ], color: Color(0xffffffff)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: dark ? const Color(0xff2f2b34) : Colors.white,
            color: Theme.of(context).primaryColorDark,
            activeColor: const Color(0xff1a74d7),
            // tabBackgroundColor: dark
            //     ? Colors.grey.shade900
            //     : Theme.of(context).primaryColorLight,
            padding: const EdgeInsets.all(15),
            gap: 8,
            tabs: const <GButton>[
              GButton(
                icon: (Icons.home),
                text: 'Home',
              ),
              GButton(
                icon: (Icons.history),
                text: 'History',
              ),
              GButton(
                icon: (Icons.remove_red_eye_outlined),
                text: 'Check Eyes',
              ),
              GButton(
                icon: (Icons.person),
                text: 'Profile',
              ),
            ],
            selectedIndex: selectedPageProvider.selectedIndex,
            onTabChange: (index) {
              selectedPageProvider.selectedIndex = index;
            },
          ),
        ),
      ),
    );
  }
}
