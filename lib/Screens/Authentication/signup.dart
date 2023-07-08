import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Constants/string_manager.dart';
import 'package:trial1/Screens/Doctor/doctor_app_layout.dart';

import '../../CustomWidgets/custom_image_view.dart';
import '../../CustomWidgets/custom_text_form_field.dart';
import '../../helpers/cache_manager.dart';
import '../../helpers/firebase_api.dart';
import '../Constants/image_constant.dart';
import '../UserScreens/AppLayout.dart';

class SignupPage extends StatefulWidget {
  final bool isUSer;

  const SignupPage({super.key, required this.isUSer});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _username = TextEditingController();
  String data = '';
  final _firebasemessaging = FirebaseMessaging.instance;
  //FirebaseAuth instance = FirebaseAuth.instance;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  bool isChecked = false;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _username.dispose();
    super.dispose();
  }

  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString("assets/TermsAndConditions.txt");
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  Future SendDetailsToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
      "uid": user.uid,
      "email": user.email,
      "username": user.displayName,
      "profilePic": user.photoURL,
      "password": ""
    });
  }

  Future signUp(String email, String password, String username, bool isUser,
      BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        //print(value);
        StringManager.uId = value.user!.uid;
        await createUser(email, password, username, isUser);
        await CacheManager.saveData('email', email);
        await CacheManager.saveData('password', password);

        Navigator.pop(context);
        if (isUser) {
          final String role = 'Patient';
          final token = await _firebasemessaging.getToken();
          saveToken(token!, FirebaseAuth.instance.currentUser!.uid);
          await CacheManager.saveData('role', role);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppLayout()),
              (route) => false);
        } else {
          final String role = 'Doctor';
          await CacheManager.saveData('role', role);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DoctorLayout()),
              (route) => false);
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future createUser(
      String email, String password, String username, bool isUser) async {
    try {
      if (!isUser) {
        await FirebaseFirestore.instance
            .collection("doctors")
            .doc(StringManager.uId)
            .set(
          {
            'uid': StringManager.uId,
            'email': email,
            'password': password,
            'username': username,
            'profilePic': '',
            'gender': '',
            'DateOfBirth': '',
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(StringManager.uId)
            .set(
          {
            'uid': StringManager.uId,
            'email': email,
            'password': password,
            'username': username,
            'profilePic': '',
            'gender': '',
            'DateOfBirth': '',
          },
        );
      }
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // elevation: 0,
          // leading: CustomImageView(
          //   url: ImageConstant.imgArrowleft,
          //   height: height * 0.025,
          //   width: width * 0.025,
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Theme.of(context).shadowColor,
                          offset: const Offset(5.0, 5.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Text(
                    "Let's Create your Account!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),

                  Column(
                    children: [
                      CustomTextFormField(
                        padding: TextFormFieldPadding.PaddingT12,
                        controller: _email,
                        hintText: 'Email Address',
                        alignment: Alignment.center,
                        prefix: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: CustomImageView(
                            svgPath: ImageConstant.imgClock,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        prefixConstraints: const BoxConstraints(maxHeight: 20),
                        fontStyle:
                            TextFormFieldFontStyle.MontserratRomanRegular16Dark,
                      ),
                      SizedBox(height: height * 0.015),
                      CustomTextFormField(
                        padding: TextFormFieldPadding.PaddingT12,
                        controller: _username,
                        hintText: 'UserName',
                        alignment: Alignment.center,
                        prefix: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: CustomImageView(
                            svgPath: ImageConstant.imgUser,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        prefixConstraints: const BoxConstraints(maxHeight: 20),
                        fontStyle:
                            TextFormFieldFontStyle.MontserratRomanRegular16Dark,
                      ),
                      SizedBox(height: height * 0.015),
                      CustomTextFormField(
                        controller: _password,
                        hintText: "Password",
                        //textInputAction: TextInputAction.done,
                        textInputType: TextInputType.visiblePassword,
                        alignment: Alignment.center,
                        prefix: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: CustomImageView(
                            svgPath: ImageConstant.imgIconTwotoneLock,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        prefixConstraints: const BoxConstraints(maxHeight: 20),
                        suffix: Container(
                          margin: const EdgeInsets.fromLTRB(30, 6, 7, 6),
                          child: CustomImageView(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              svgPath: isPasswordVisible
                                  ? ImageConstant.imgCheckmark
                                  : ImageConstant.eyeOpened,
                              height: 20,
                              width: 20),
                        ),
                        suffixConstraints: const BoxConstraints(maxHeight: 44),
                        isObscureText: isPasswordVisible,
                        fontStyle:
                            TextFormFieldFontStyle.MontserratRomanRegular16Dark,
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      CustomTextFormField(
                        controller: _confirmPassword,
                        hintText: "Confirm Password",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.visiblePassword,
                        alignment: Alignment.center,
                        prefix: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: CustomImageView(
                            svgPath: ImageConstant.imgLock,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        prefixConstraints: const BoxConstraints(maxHeight: 20),
                        suffix: Container(
                          margin: const EdgeInsets.fromLTRB(30, 6, 7, 6),
                          child: CustomImageView(
                              onTap: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                });
                              },
                              svgPath: isConfirmPasswordVisible
                                  ? ImageConstant.imgCheckmark
                                  : ImageConstant.eyeOpened,
                              height: 20,
                              width: 20),
                        ),
                        suffixConstraints: const BoxConstraints(maxHeight: 44),
                        isObscureText: isConfirmPasswordVisible,
                        fontStyle:
                            TextFormFieldFontStyle.MontserratRomanRegular16Dark,
                      ),
                      SizedBox(height: height * 0.01),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImageView(
                            svgPath: (isChecked == false)
                                ? ImageConstant.imgIcontwotonemaximize2
                                : ImageConstant.imgCheckmarkBlack900,
                            width: 20,
                            height: 20,
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                          ),
                          // Checkbox(
                          //   value: isChecked,
                          //   activeColor: Colors.blue,
                          //   onChanged: (newBool) {
                          //     setState(() {
                          //       isChecked = newBool!;
                          //     });
                          //   },
                          // ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet<dynamic>(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  constraints: BoxConstraints(
                                    maxHeight: height * 0.9,
                                    minHeight: height * 0.2,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(43),
                                      topRight: Radius.circular(43),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Wrap(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.03),
                                                      height: 176,
                                                      width: 176,
                                                      child: Image.asset(
                                                          "lib/images/Frame 2.png")),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width * 0.03),
                                                    child: const Text(
                                                      "Terms & Conditions",
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: Text(
                                                        data,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          // overflow: TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Center(
                                                    child: CustomButton(
                                                        label: "I Accept",
                                                        onPressed: () {
                                                          setState(() {
                                                            isChecked = true;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "Agree to the terms and conditions",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ))
                        ]),
                  ),

                  SizedBox(
                    height: height * 0.04,
                  ),
                  Center(
                    child: CustomButton(
                      onPressed: () async {
                        final String email = _email.text.trim();
                        final String password = _password.text.trim();
                        final String username = _username.text.trim();
                        final String confirmPassword =
                            _confirmPassword.text.trim();
                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        } else if (isChecked == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please accept the terms and conditions'),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }
                        await signUp(
                            email, password, username, widget.isUSer, context);
                      },
                      label: 'SignUp',
                      width: width * 0.5,
                      height: height * 0.06,
                    ),
                  ),

                  SizedBox(
                    height: height * 0.025,
                  ),

                  /// or register using
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Register Using',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14.0),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SizedBox(
                          width: width * 0.4,
                          height: height * 0.1,
                          child: InkWell(
                              splashColor: Colors.black26,
                              onTap: () {
                                _signInWithGoogle()
                                    .then((UserCredential? userCredential) {
                                  if (userCredential
                                          ?.additionalUserInfo?.isNewUser ==
                                      true) {
                                    SendDetailsToFirestore();
                                  }

                                  // Handle successful sign-in
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppLayout()),
                                      (route) => false);
                                }).catchError((e) {
                                  //print(e);
                                  // Handle sign-in error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              },
                              child: const SquareTile(
                                  imagePath:
                                      'lib/images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png'))),
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
