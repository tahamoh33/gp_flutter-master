import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trial1/Screens/Doctor/DoctorEditProfile.dart';
import 'package:trial1/Screens/NavigationScreens/Profile.dart';
import 'package:trial1/Screens/cache_manager.dart';

import '../Authentication/Login.dart';

class DoctorshowProfile extends StatefulWidget {
  const DoctorshowProfile({super.key});

  @override
  State<DoctorshowProfile> createState() => _DoctorshowProfile();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _DoctorshowProfile extends State<DoctorshowProfile> {
  String userId = "";
  String email = "";
  String userName = "";
  String imageUrl = "";

  Future<String> getUserPic() async {
    final String userId = _auth.currentUser!.uid;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("doctors")
          .doc(userId)
          .get();
      imageUrl = snapshot['profilePic'];
      return imageUrl;
    } catch (e) {
      return '';
    }
  }

  Future<String> fetchUserName() async {
    final String? userId = _auth.currentUser?.uid;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      userName = snapshot.get('username');

      return userName;
    } catch (e) {
      print('Error fetching user name: $e');
      return '';
    }
  }

  Future<String> fetchemail() async {
    final String? userId = _auth.currentUser?.uid;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      email = snapshot.get('email');

      return email;
    } catch (e) {
      print('Error fetching user email: $e');
      return '';
    }
  }

  void initState() {
    getUserPic().then((value) => setState(() {}));
    super.initState();
    fetchUserName();
    fetchemail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Center(
            child: Text(
              "Profile",
              style: TextStyle(fontSize: 25, color: Colors.blue),
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
              width: 40,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                (imageUrl != "")
                    ? imageUrl
                    : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                height: 250,
                width: 250,
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //     decoration: BoxDecoration(shape: BoxShape.circle),
            //     height: 30,
            //     width: 250,
            //     child: FittedBox(
            //       fit: BoxFit.contain,
            //       child: FutureBuilder<String>(
            //         future: fetchUserName(),
            //         builder: (BuildContext context,
            //             AsyncSnapshot<String> snapshot) {
            //           // if (snapshot.connectionState == ConnectionState.waiting) {
            //           //   return CircularProgressIndicator();
            //           // } else
            //           if (snapshot.hasError) {
            //             return Text('Error: ${snapshot.error}');
            //           } else {
            //             return Text(
            //               email,
            //               maxLines: 1,
            //               style: TextStyle(
            //                 fontFamily: "montserrat",
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             );
            //           }
            //         },
            //       ),
            //     )),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 30,
                width: 250,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: FutureBuilder<String>(
                    future: fetchUserName(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return CircularProgressIndicator();
                      // } else
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          userName,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: "montserrat",
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    },
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 30,
                width: 250,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: FutureBuilder<String>(
                    future: fetchemail(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          email,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: "montserrat",
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      }
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => editDoctorProfile())))
                      .then((value) {
                    if (value == true) {
                      fetchUserName();
                      getUserPic();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).hintColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  " Edit profile",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () async {
                await CacheManager.removeData('email');
                await CacheManager.removeData('password');
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => Login())));
                await _auth.signOut();
              },
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).hintColor),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Log out",
                style: TextStyle(
                    fontFamily: "montserrat",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark),
              ),
            )
          ],
        ),
      ),
    );
  }
}
