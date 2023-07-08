import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/CustomWidgets/custom_image_view.dart';

import '../State Management/selected_page_provider.dart';

class doctor extends StatefulWidget {
  const doctor({super.key});

  @override
  State<doctor> createState() => _doctorState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _doctorState extends State<doctor> {
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
          .collection("doctors")
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
          .collection("doctors")
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, bottom: 30, right: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageView(
                url: (imageUrl != "")
                    ? imageUrl
                    : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                height: 82,
                width: 82,
              ),

              const SizedBox(
                height: 5,
              ),
              Text(
                username == "" ? "Hello, User" : "Hello, $username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const SizedBox(
                height: 10,
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
                      color: const Color(0xff000000),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We are glad to have you back, we hope you are doing well and we wish you a great day !",
                    maxLines: 4,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                // width: 188,
                // height: 22,
                child: const Text(
                  "Are You Ready To Help Us?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 195,
                  height: 228.378,
                  child: InkWell(
                    child: Image.asset("lib/images/DrScreen.png"),
                  ),
                ),
              ),
              Container(
                // height: 125,
                // width: 306,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      """View Predictions function helps Us keep track of the Detection results and the Accuracy of the model Predictions which helps us to modify the application to reach higher accuracy.
                      
Thank you for helping us !""",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "thank you for helping us !",
                    //   maxLines: 2,
                    //   style: TextStyle(
                    //     fontFamily: 'Montserrat',
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).hintColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadowColor: Theme.of(context).shadowColor,
                    minimumSize: const Size(125, 50),
                  ),
                  onPressed: () {
                    selectedPageProvider.selectedIndex = 1;
                  },
                  child: Text(
                    "View Predictions",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // child: CustomButton(
              //     height: 50,
              //     width: 200,
              //     label: "View Predictions",
              //     onPressed: () {
              //       selectedPageProvider.selectedIndex = 1;
              //     }))
//bos keda
              //View Predictions function helps Us keep track of the Detection results and the Accuracy of the model Predictions which helps us to modify the application to reach higher accuracy.
              //
              // thank you for helping us !
            ],
          ),
        ),
      ),
    );
  }
}
