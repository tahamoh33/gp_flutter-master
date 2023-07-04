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

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "Hello, $username",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Take A Deep Breath And Let's Discover Your Eye Disease",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                child: Text(
                  "What Do You Need?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 130,
                      child: InkWell(
                        onTap: () {},
                        child: Ink.image(
                          image: AssetImage('lib/images/icon_check.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: 20,
                          // width: 95,
                          child: Text(
                            "Check Eyes",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 186,
                          // height: 45,
                          child: const Text(
                            """Upload your eye picture and Remember!
The better picture the better diagnosis.""",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1,
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
                        //_image==null? Container() :Image.file(_image,height: 300,width: 300,),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // height: 130,
                // width: 360,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 112,
                        height: 130,
                        child: InkWell(
                          onTap: () {},
                          child: Ink.image(
                            image: AssetImage('lib/images/icon_history.png'),
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
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: 20,
                            // width: 95,
                            child: Text(
                              "View History",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 186,
                            // height: 45,
                            child: Text(
                              """History function helps keep track of the Detection results and the diseases you have.""",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          TextButton(
                            onPressed: () {
                              selectedPageProvider.selectedIndex = 1;
                            },
                            child: Text(
                              "View History",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
