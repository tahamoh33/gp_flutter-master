import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trial1/Screens/NavigationScreens/show_profile.dart';

import '../State Management/selected_page_provider.dart';
import 'DoctorScreen.dart';

class DoctorLayout extends StatefulWidget {
  const DoctorLayout({super.key});

  @override
  State<DoctorLayout> createState() => DoctorLayoutState();
}

class DoctorLayoutState extends State<DoctorLayout> {
  List Screens = [doctor(), doctor(), showProfile()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final selectedPageProvider =
          Provider.of<SelectedPageProvider>(context, listen: false);
      selectedPageProvider.selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            icon: Icon(Icons.file_copy_outlined),
            label: 'Prescriptions',
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
