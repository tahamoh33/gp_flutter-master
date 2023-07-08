import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/custom_image_view.dart';
import 'package:trial1/CustomWidgets/custom_text_form_field.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Authentication/forgot_pw.dart';
import 'package:trial1/helpers/cache_manager.dart';
import 'package:trial1/helpers/firebase_api.dart';

import '../Constants/image_constant.dart';
import '../Constants/string_manager.dart';
import '../Doctor/doctor_app_layout.dart';
import '../UserScreens/AppLayout.dart';
import '../UserScreens/welcome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebasemessaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isPasswordVisible = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // sign in with google
  Future createUser(String email, String password, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(StringManager.uId)
          .set(
        {
          'uid': StringManager.uId,
          'email': email,
          'password': password,
          'username': username,
          'profilePic': ''
        },
      );
    } catch (e) {
      //print(e);
    }
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
        await _auth.signInWithCredential(credential);
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

  // sign in function
  Future signIn() async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final role = await checkUserRole();
      await CacheManager.saveData('email', _emailController.text);
      await CacheManager.saveData('password', _passwordController.text);
      await CacheManager.saveData('role', role);
      if (role == 'Patient') {
        final token = await _firebasemessaging.getToken();
        saveToken(token!, _auth.currentUser!.uid);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppLayout()),
            (route) => false);
      } else if (role == 'Doctor') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DoctorLayout()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown User'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
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

  // a function that checks if the logged in user is a doctor or a patient from firestore collections
  Future checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final patientQuery = FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid);

      final doctorQuery = FirebaseFirestore.instance
          .collection('doctors')
          .where('uid', isEqualTo: uid);

      final patientSnapshot = await patientQuery.get();
      final doctorSnapshot = await doctorQuery.get();

      if (patientSnapshot.docs.isNotEmpty) {
        return 'Patient';
      } else if (doctorSnapshot.docs.isNotEmpty) {
        return 'Doctor';
      } else {
        return 'Unknown';
      }
    } else {
      return 'User Not Logged In';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              SizedBox(height: height * 0.03),
              SizedBox(
                width: width * 0.5,
                height: height * 0.05,
                //margin: EdgeInsets.only(left: width * 0.1),
                child: AutoSizeText(
                  'Login',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Theme.of(context).shadowColor,
                        offset: const Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  stepGranularity: 1,
                ),
              ),
              // SizedBox(
              //   height: height * 0.02,
              // ),
              SizedBox(
                //margin: EdgeInsets.only(left: width * 0.1, top: height * 0.02),
                width: width * 0.3,
                height: height * 0.05,
                child: Text(
                  "Glad To See You Again! ",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextFormField(
                padding: TextFormFieldPadding.PaddingT12,
                controller: _emailController,
                hintText: 'Email Address',
                alignment: Alignment.center,
                prefix: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: CustomImageView(
                    svgPath: ImageConstant.imgClock,
                    width: 20,
                    height: 20,
                  ),
                ),
                prefixConstraints: const BoxConstraints(maxHeight: 20),
                fontStyle: TextFormFieldFontStyle.MontserratRomanRegular16Dark,
              ),

              SizedBox(
                height: height * 0.02,
              ),
              CustomTextFormField(
                controller: _passwordController,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                alignment: Alignment.center,
                prefix: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                fontStyle: TextFormFieldFontStyle.MontserratRomanRegular16Dark,
              ),
              SizedBox(
                height: height * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Forgotpw())));
                    },
                    child: Text(
                      "Forgot password ?",
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontFamily: "Montserrat",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: height * 0.02,
              ),

              //width: double.infinity,

              Center(
                child: CustomButton(
                  onPressed: signIn,
                  width: width * 0.3,
                  height: height * 0.06,
                  label: 'Login',
                ),
              ),

              SizedBox(
                height: height * 0.03,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                width: width * 0.5,
                height: height * 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: width * 0.5,
                        height: height * 0.01,
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        " Or Login With ",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: width * 0.5,
                        height: height * 0.01,
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                      builder: (context) => const AppLayout()),
                                  (route) => false);
                            }).catchError((e) {
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
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                // margin: EdgeInsets.only(right: width * 0.1, left: width * 0.1),
                width: width * 0.1,
                height: height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        AutoSizeText(
                          'Don\'t Have an Account ?',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          stepGranularity: 1,
                        ),
                        SizedBox(height: height * 0.01),
                        GestureDetector(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()),
                                  (route) => false);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xff1a74d7),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
