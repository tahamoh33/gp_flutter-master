import 'package:flutter/material.dart';
import 'package:trial1/Screens/Authentication/Login.dart';
import 'package:trial1/Screens/Authentication/signup.dart';

import '../../CustomWidgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = this.isDarkMode(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDarkMode ? 'lib/images/logo_dark.png' : 'lib/images/logo.png',
              width: width * 0.5,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text(
              'Easy And Convenient Online Check-up On Your Eyes Right From Your Home',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text(
              "Sign Up As:",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Theme.of(context).primaryColorDark),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    height: height * 0.06,
                    width: width * 0.35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const SignupPage(
                                    isUSer: true,
                                  ))));
                    },
                    label: 'User',
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  CustomButton(
                    height: height * 0.06,
                    width: width * 0.35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const SignupPage(
                                    isUSer: false,
                                  ))));
                    },
                    label: 'Doctor',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColorDark),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Login())));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
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
