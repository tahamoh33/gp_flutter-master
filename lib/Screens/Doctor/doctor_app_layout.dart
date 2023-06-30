import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:trial1/Screens/Doctor/DoctorShowProfile.dart';

import '../../new_history.dart';
import '../State Management/selected_page_provider.dart';
import 'DoctorScreen.dart';

class DoctorLayout extends StatefulWidget {
  const DoctorLayout({super.key});

  @override
  State<DoctorLayout> createState() => DoctorLayoutState();
}

class DoctorLayoutState extends State<DoctorLayout> {
  List Screens = [doctor(), Doctorhistory(), DoctorshowProfile()];

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
    final dark;
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);
    if (Brightness.dark == MediaQuery.of(context).platformBrightness) {
      dark = true;
    } else {
      dark = false;
    }
    return Scaffold(
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
        //color: dark ? Color(0xff2f2b34) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: dark ? Color(0xff2f2b34) : Colors.white,
            color: Theme.of(context).primaryColorDark,
            activeColor: const Color(0xff1a74d7),
            tabBackgroundColor: dark
                ? Colors.grey.shade900
                : Theme.of(context).primaryColorLight,

            padding: EdgeInsets.all(15),
            gap: 8,
            tabs: const <GButton>[
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.file_copy_outlined,
                text: 'Prescriptions',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: selectedPageProvider.selectedIndex,
            //selectedItemColor: const Color(0xff1a74d7),

            //unselectedItemColor: Colors.grey,
            onTabChange: (index) {
              selectedPageProvider.selectedIndex = index;
            },
          ),
        ),
      ),
    );
  }
}
