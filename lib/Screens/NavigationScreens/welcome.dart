import 'package:flutter/material.dart';
import 'package:trial1/Screens/Authentication/Login.dart';
import 'package:trial1/Screens/Authentication/signup.dart';

import '../../CustomWidgets/custom_button.dart';
import '../Constants/color_manager.dart';




class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/logo.png',
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Easy And Convenient Online Check-up On Your Eyes Right From Your Home',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Sign Up As:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize:18
            ),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  CustomButton(
                    height:50,
                    width:145,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                              ((context) => SignupPage())));
                    },
                    label:  'User',
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  CustomButton(
                    height:50,
                    width:145,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                              ((context) => SignupPage())));
                    },
                    label:  'Doctor',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                            ((context) =>Login())));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      //color: ColorManager.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
