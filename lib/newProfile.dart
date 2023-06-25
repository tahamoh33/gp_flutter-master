import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'CustomWidgets/custom_image_view.dart';
import 'CustomWidgets/custom_text_form_field.dart';
import 'Screens/Authentication/Login.dart';
import 'Screens/Constants/image_constant.dart';
import 'Screens/cache_manager.dart';

// ignore_for_file: must_be_immutable
class ProfileScreen2 extends StatefulWidget {
  ProfileScreen2({Key? key}) : super(key: key);

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  String url = "";
  var image;
  bool isObscureText = true;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  File? _image;
  final picker = ImagePicker();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<XFile?> resizeImage(File imageFile, int width, int height) async {
    // Generate a unique file path for the compressed image
    String newPath =
        '${imageFile.path}_compressed.${imageFile.path.split('.').last.toLowerCase()}';
    var compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      newPath,
      quality: 80, // Set the desired image quality (0 - 100)
      minWidth: width,
      minHeight: height,
    );

    return compressedImageFile;
  }

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

  pickImageFromGallery() async {
    image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    // loading circle
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    // compress image
    File? compressedImage = (await resizeImage(_image!, 500, 500)) as File?;
    await uploadImageToFirebase(compressedImage!);
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
            _password.text = userData['password'];
          } catch (e) {
            _password.text = "";
          }
          _username.text = userData['username'];
          try {
            url = userData['profilePic'];
          } catch (e) {
            url = "";
          }
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Getting User Data due to ${e}!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future updateUser(String uid, String email, String password, String username,
      String url) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      User? user = FirebaseAuth.instance.currentUser;
      // Create a map with the updated user data
      //print('url2: $url ');
      final updatedUserData = {
        'email': email,
        'password': password,
        'username': username,
        'profilePic': url,
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
          content: Text('Error Updating due to ${e}!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    _password.dispose();
    url = "";
    // _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextButton(
              onPressed: () async {
                final String email = _email.text.trim();
                final String password = _password.text.trim();
                final String username = _username.text.trim();
                await updateUser(instance.currentUser!.uid, email, password,
                        username, url)
                    .then((value) => setState(() {}));

                //Navigator.pop(context, true);
              },
              child: Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
                fontSize: 25, color: Theme.of(context).colorScheme.secondary),
          )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: height,
                    //margin: EdgeInsets.only(top: 41),
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Positioned(
                          top: height * 0.1,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 52, vertical: 77),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0x1f939393),
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
                                        style: TextStyle(
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
                                            padding: EdgeInsets.only(
                                                left: 1, top: 78),
                                            child: Text("Email",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _email,
                                            hintText: "Taha Mohamed",
                                            margin: EdgeInsets.only(
                                                left: 1, top: 11),
                                            width: width * 0.8,
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: TextFormFieldFontStyle
                                                .MontserratRomanRegular14),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 1, top: 23),
                                            child: Text("UserName",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _username,
                                            hintText: "Taha Mohamed",
                                            width: width * 0.8,
                                            margin: EdgeInsets.only(
                                                left: 1, top: 11),
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: TextFormFieldFontStyle
                                                .MontserratRomanRegular14),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 2, top: 23),
                                            child: Text("Password",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                        CustomTextFormField(
                                            autofocus: false,
                                            controller: _password,
                                            width: width * 0.8,
                                            hintText: "************",
                                            suffix: Container(
                                              child: CustomImageView(
                                                  onTap: () {
                                                    print("alo");
                                                    setState(() {
                                                      isObscureText =
                                                          !isObscureText;
                                                    });
                                                  },
                                                  svgPath: isObscureText
                                                      ? ImageConstant.eyeOpened
                                                      : ImageConstant
                                                          .imgCheckmark,
                                                  height: 20,
                                                  width: 20),
                                            ),
                                            suffixConstraints: BoxConstraints(
                                                maxHeight: 20, maxWidth: 20),
                                            isObscureText: isObscureText,
                                            margin: EdgeInsets.only(
                                                left: 1, top: 9),
                                            variant: TextFormFieldVariant
                                                .UnderLineGray40001,
                                            fontStyle: TextFormFieldFontStyle
                                                .MontserratRomanRegular14,
                                            textInputAction:
                                                TextInputAction.done),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 2, top: 28, bottom: 86),
                                            child: Row(children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2),
                                                  child: Text("Logout",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ))),
                                              CustomImageView(
                                                  onTap: () async {
                                                    print("Log out");
                                                    await CacheManager
                                                        .removeData('email');
                                                    await CacheManager
                                                        .removeData('password');
                                                    await CacheManager
                                                        .removeData('role');
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) =>
                                                                    Login())));
                                                    await instance.signOut();
                                                  },
                                                  svgPath: ImageConstant.imgCut,
                                                  height: (22),
                                                  width: (17),
                                                  margin: EdgeInsets.only(
                                                      left: 10)),
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
                                              offset: Offset(0, 4))
                                        ])),
                                SizedBox(
                                    height: 80,
                                    width: 77,
                                    child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CustomImageView(
                                              onTap: () {
                                                print(url);
                                                print("onTap called.");
                                              },
                                              url: url,
                                              height: 80,
                                              width: 77,
                                              alignment: Alignment.center),
                                          Container(
                                              height: 17,
                                              width: 17,
                                              margin: EdgeInsets.only(
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
                                                        margin: EdgeInsets.only(
                                                            top: 4))
                                                  ]))
                                        ]))
                              ]))),
                    ]))
              ])),
    );
  }
}
