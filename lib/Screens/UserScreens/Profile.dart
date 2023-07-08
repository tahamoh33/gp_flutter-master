import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../CustomWidgets/custom_image_view.dart';
import '../../CustomWidgets/custom_text_form_field.dart';
import '../../helpers/cache_manager.dart';
import '../Authentication/Login.dart';
import '../Constants/image_constant.dart';

// ignore_for_file: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String url = "";
  var image;
  bool isObscureText = true;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  File? _image;
  final picker = ImagePicker();
  final _email = TextEditingController();
  final _Gender = TextEditingController();
  final _username = TextEditingController();
  final _birth = TextEditingController();
  DateTime selectedDate = DateTime(2000, 5, 21);
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<String> uploadImageToFirebase(File image) async {
    //Upload image to firebase
    String filename = "${instance.currentUser!.email}.jpg";
    await FirebaseStorage.instance
        .ref()
        .child('profiles/ $filename')
        .putFile(image)
        .then((value) => (value.ref.getDownloadURL()).then((value) {
              url = value;
            }));
    return url;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birth.value = TextEditingValue(
            text: formatter.format(
                picked)); //Use formatter to format selected date and assign to text field
      });
    }
  }

  pickImageFromGallery() async {
    image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 2048,
      maxWidth: 2048,
    );
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    // loading circle
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // compress image
    await uploadImageToFirebase(_image!).then((value) {
      setState(() {
        url = value;
      });
    });
    Navigator.pop(context);
  }

  Future getUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _email.text = userData['email'];
          try {
            _Gender.text = userData['Gender'];
          } catch (e) {
            _Gender.text = "";
          }
          _username.text = userData['username'];
          try {
            url = userData['profilePic'];
          } catch (e) {
            url = "";
          }
          try {
            _birth.text = userData['Date of Birth'];
          } catch (e) {
            _birth.text = "";
          }
        });
      }
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Getting User Data due to $e!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future updateUser(String uid, String email, String gender, String username,
      String Birth, String url) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      User? user = FirebaseAuth.instance.currentUser;
      // Create a map with the updated user data
      //print('url2: $url ');
      final updatedUserData = {
        'email': email,
        'Gender': gender,
        'username': username,
        'profilePic': url,
        'Date of Birth': Birth,
      };

      if (user != null) {
        await user.updateEmail(email);
      }
      // Update the document with the new user data
      await userRef.update(updatedUserData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Updating due to $e!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _birth.dispose();
    _Gender.dispose();
    url = "";
    // _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = isDarkMode(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextButton(
                onPressed: () async {
                  final String email = _email.text.trim();
                  final String gender = _Gender.text.trim();
                  final String username = _username.text.trim();
                  final String birth = _birth.text.trim();
                  await updateUser(instance.currentUser!.uid, email, gender,
                          username, birth, url)
                      .then((value) => setState(() {}));

                  //Navigator.pop(context, true);
                },
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 25, color: Theme.of(context).hintColor),
          )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: height,
                    //margin: EdgeInsets.only(top: 41),
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Positioned(
                          top: height * 0.1,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 52, vertical: 77),
                              decoration: BoxDecoration(
                                  color:
                                      isDark ? Color(0xff3a3a3a) : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x1f939393),
                                        blurRadius: 0,
                                        offset: Offset(0, 0),
                                        spreadRadius: 4)
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(73))),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_username.text,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1, top: 78),
                                            child: Text("Email",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _email,
                                            //hintText: "Taha Mohamed",
                                            margin: const EdgeInsets.only(
                                                left: 1, top: 11),
                                            width: width * 0.8,
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: !isDark
                                                ? TextFormFieldFontStyle
                                                    .MontserratRomanRegular14
                                                : TextFormFieldFontStyle
                                                    .MontserratRomanRegular14White),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1, top: 23),
                                            child: Text("UserName",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _username,
                                            hintText: "Username",
                                            // onChanged: (value) {
                                            //   setState(() {
                                            //     showDialog(
                                            //         context: context,
                                            //         builder: (BuildContext
                                            //                 context) =>
                                            //             AlertDialog(
                                            //               title: Text(
                                            //                   "Change Username"),
                                            //               content: Text(
                                            //                   "Are you sure you want to change your username?"),
                                            //               actions: [
                                            //                 TextButton(
                                            //                     onPressed: () {
                                            //                       Navigator.pop(
                                            //                           context);
                                            //                     },
                                            //                     child:
                                            //                         Text("No")),
                                            //                 TextButton(
                                            //                     onPressed:
                                            //                         () async {
                                            //                       await instance
                                            //                           .currentUser!
                                            //                           .updateDisplayName(
                                            //                               value);
                                            //                       Navigator.pop(
                                            //                           context);
                                            //                     },
                                            //                     child: Text(
                                            //                         "Yes")),
                                            //               ],
                                            //             ));
                                            //   });
                                            // },
                                            margin: const EdgeInsets.only(
                                                left: 1, top: 11),
                                            width: width * 0.8,
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: !isDark
                                                ? TextFormFieldFontStyle
                                                    .MontserratRomanRegular14
                                                : TextFormFieldFontStyle
                                                    .MontserratRomanRegular14White),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2, top: 23),
                                            child: Text("Gender",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _Gender,
                                            width: width * 0.8,
                                            hintText: "Male",
                                            margin: const EdgeInsets.only(
                                                left: 1, top: 9),
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: !isDark
                                                ? TextFormFieldFontStyle
                                                    .MontserratRomanRegular14
                                                : TextFormFieldFontStyle
                                                    .MontserratRomanRegular14White,
                                            textInputAction:
                                                TextInputAction.done),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2, top: 23),
                                            child: Text("Date of Birth",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _birth,
                                            width: width * 0.8,
                                            hintText: "21/5/2000",
                                            onTap: () {
                                              setState(() {
                                                _selectDate(context);
                                              });
                                            },
                                            // suffix: CustomImageView(
                                            //     imagePath:
                                            //         ImageConstant.EditDate,
                                            //     onTap: () {
                                            //       setState(() {
                                            //         _selectDate(context);
                                            //       });
                                            //     },
                                            //     height: 20,
                                            //     width: 20),
                                            suffixConstraints:
                                                const BoxConstraints(
                                                    maxHeight: 20,
                                                    maxWidth: 20),
                                            margin: const EdgeInsets.only(
                                                left: 1, top: 9),
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: !isDark
                                                ? TextFormFieldFontStyle
                                                    .MontserratRomanRegular14
                                                : TextFormFieldFontStyle
                                                    .MontserratRomanRegular14White,
                                            textInputAction:
                                                TextInputAction.done),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2, top: 28, bottom: 86),
                                            child: Row(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Text("Logout",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ))),
                                              CustomImageView(
                                                  onTap: () async {
                                                    //print("Log out");
                                                    await CacheManager
                                                        .removeData('email');
                                                    await CacheManager
                                                        .removeData('password');
                                                    await CacheManager
                                                        .removeData('role');
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                const Login())));
                                                    await instance.signOut();
                                                  },
                                                  svgPath: ImageConstant.imgCut,
                                                  height: (22),
                                                  width: (17),
                                                  margin: const EdgeInsets.only(
                                                      left: 10)),
                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     print("save");
                                              //   },
                                              //   child: Text(
                                              //     "Save Changes",
                                              //     style: TextStyle(
                                              //         color: Colors.white),
                                              //   ),
                                              //   style: ElevatedButton.styleFrom(
                                              //     primary: Theme.of(context)
                                              //         .hintColor,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               10),
                                              //     ),
                                              //   ),
                                              // )
                                            ]))
                                      ],
                                    ),
                                  ]))),
                      Positioned(
                          top: 40,
                          child: SizedBox(
                              height: 87,
                              width: 83,
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                    height: 87,
                                    width: 83,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(43),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 4))
                                        ])),
                                SizedBox(
                                    height: 80,
                                    width: 77,
                                    child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CustomImageView(
                                              onTap: () {
                                                pickImageFromGallery();
                                              },
                                              url: (url != "")
                                                  ? url
                                                  : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                                              height: 80,
                                              width: 77,
                                              alignment: Alignment.center),
                                          Container(
                                              height: 17,
                                              width: 17,
                                              margin: const EdgeInsets.only(
                                                  right: 2, bottom: 3),
                                              child: Stack(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgIconcheckcircled,
                                                        height: 17,
                                                        width: 17,
                                                        alignment:
                                                            Alignment.center),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgPen,
                                                        height: 8,
                                                        width: 8,
                                                        alignment:
                                                            Alignment.topCenter,
                                                        margin: const EdgeInsets
                                                            .only(top: 4))
                                                  ]))
                                        ]))
                              ]))),
                    ]))
              ])),
    );
  }
}
