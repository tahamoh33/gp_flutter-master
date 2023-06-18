import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Authentication/forgot_pw.dart';
import 'package:trial1/Screens/Authentication/signup.dart';
import 'package:trial1/Screens/cache_manager.dart';

import '../NavigationScreens/AppLayout.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  FirebaseAuth instance = FirebaseAuth.instance;
  bool isPasswordVisible = true;

  final _emailController = TextEditingController(text: 'atom1@gmail.com');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // sign in function
  Future signIn() async {
    try {
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await CacheManager.saveData('email', _emailController.text);
      await CacheManager.saveData('password', _passwordController.text);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppLayout()),
          (route) => false);
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white, systemOverlayStyle: SystemUiOverlayStyle.dark),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
          children: [
            SizedBox(height: height * 0.03),
            Container(
              width: width * 0.5,
              height: height * 0.05,
              margin: EdgeInsets.only(left: width * 0.1),
              child: AutoSizeText(
                'Login',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(5.0, 5.0),
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
            Container(
              margin: EdgeInsets.only(left: width * 0.1, top: height * 0.02),
              width: width * 0.3,
              height: height * 0.05,
              child: Text(
                "Glad To See You Again! ",
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person_outline_sharp),
              ),
            ),

            SizedBox(
              height: height * 0.02,
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: isPasswordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )),
            ),

            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Forgotpw())));
                  },
                  child: Text(
                    "Forgot password ?",
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey[600],
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
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              width: width * 0.5,
              height: height * 0.05,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
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
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
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

            Container(
              //margin: EdgeInsets.fromLTRB(38, 0,0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: width * 0.25,
                      height: height * 0.09,
                      child: InkWell(
                          splashColor: Colors.black26,
                          onTap: () {},
                          child: SquareTile(
                              imagePath:
                                  'lib/images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png'))),
                  SizedBox(
                    width: width * 0.15,
                  ),
                  Container(
                      width: width * 0.25,
                      height: height * 0.09,
                      child: InkWell(
                          splashColor: Colors.black26,
                          onTap: () {},
                          child: SquareTile(
                              imagePath:
                                  'lib/images/Facebook_Logo_(2019).png')))
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
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
                          color: Colors.grey[700],
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => SignupPage())));
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
    );
  }
}
