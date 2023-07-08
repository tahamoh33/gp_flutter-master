import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/State%20Management/selected_page_provider.dart';

import '../../CustomWidgets/custom_image_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String email = "";
  String uid = "";
  String username = "";
  String imageUrl = "";

  void initState() {
    super.initState();
    getUsername();
    getUserPic();
  }

  Future<String> getUsername() async {
    final String userId = _auth.currentUser!.uid;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      setState(() {
        username = snapshot['username'];
      });
      return username;
    } catch (e) {
      return '';
    }
  }

  Future<String> getUserPic() async {
    final String userId = _auth.currentUser!.uid;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      setState(() {
        imageUrl = snapshot['profilePic'];
      });
      return imageUrl;
    } catch (e) {
      return '';
    }
  }

  bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = isDarkMode(context);
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                      url: (imageUrl != "")
                          ? imageUrl
                          : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                      height: 80,
                      width: 80,
                      alignment: Alignment.center),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Hello, $username",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back !",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Take A Deep Breath And Let's Discover Your Eye Disease",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.05,
              ),
              const Text(
                "What Do You Need?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Stack(
                children: [
                  Container(
                    width: 332,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x05000000),
                            offset: Offset(-2, 6),
                            blurRadius: 4,
                            spreadRadius: 6)
                      ],
                      color: !isDark ? Color(0xffffffff) : Color(0xffe4e2e6),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 112,
                        height: 136,
                        child: InkWell(
                          onTap: () {},
                          child: CustomImageView(
                            imagePath: ('lib/images/icon_check.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              "Check Eyes",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 186,
                            // height: 45,
                            child: Text(
                              """  Upload A Picture of Your Eye
  Remember! The Better Picture,
  The Better Diagnosis.""",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              selectedPageProvider.selectedIndex = 2;
                            },
                            child: Text(
                              "Let’s Check!",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    width: 332,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x05000000),
                            offset: Offset(-2, 6),
                            blurRadius: 4,
                            spreadRadius: 6)
                      ],
                      color: !isDark
                          ? const Color(0xffffffff)
                          : const Color(0xffe4e2e6),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 112,
                        height: 136,
                        child: InkWell(
                          onTap: () {},
                          child: CustomImageView(
                            imagePath: ('lib/images/icon_history.png'),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: 220,
                      //   height: 130,
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).primaryColor,
                      //     borderRadius: BorderRadius.circular(40),
                      //     boxShadow: [
                      //       BoxShadow(
                      //           color: Colors.black26.withOpacity(0.1),
                      //           offset: Offset(0, 25),
                      //           blurRadius: 3,
                      //           spreadRadius: -17),
                      //     ],
                      //   ),
                      //   child:
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "View History",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: 186,
                            // height: 45,
                            child: Text(
                              """  History function helps keep track
  of the Detection results and
  the diseases you have.""",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorDark),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          TextButton(
                            onPressed: () {
                              selectedPageProvider.selectedIndex = 1;
                            },
                            child: Text(
                              "Show History",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
