import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Constants/string_manager.dart';
import 'package:trial1/Screens/NavigationScreens/AppLayout.dart';
import 'package:trial1/Screens/OnBoardingScreen.dart';

import '../cache_manager.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _email = new TextEditingController();
  final _password = new TextEditingController();
  final _confirmPassword = new TextEditingController();
  final _username = new TextEditingController();

  //FirebaseAuth instance = FirebaseAuth.instance;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => OnBoardingScreen())));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(5.0, 5.0),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Let's Create your Account!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Column(
                  children: [
                    TextField(
                      //onChanged: (value) {
                      //setState(() {
                      //this._email = value as TextEditingController;
                      // });
                      //},
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        hintText: 'Email Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _username,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _password,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _confirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        hintText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: isConfirmPasswordVisible
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) => false,
                  ),
                  Text("Agree to the terms and conditions",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ]),

                SizedBox(
                  height: 20.0,
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
                          SnackBar(
                            content: Text('Passwords do not match'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      await signUp(email, password, username, context);
                    },
                    label: 'SignUp',
                    width: 150,
                    height: 50,
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Center(
                //   child: CustomButton(
                //     onPressed: () async {
                //       await getUser(StringManager.uId);
                //     },
                //     label: 'get data',
                //     width: 150,
                //     height: 50,
                //   ),
                // ),
                SizedBox(
                  height: 20,
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
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
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
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    Container(
                        width: 121,
                        height: 75,
                        child: InkWell(
                            splashColor: Colors.black26,
                            onTap: () {},
                            child: SquareTile(
                                imagePath:
                                    'lib/images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png'))),
                    SizedBox(
                      width: 54.0,
                    ),
                    Container(
                        width: 121,
                        height: 75,
                        child: InkWell(
                            splashColor: Colors.black26,
                            onTap: () {},
                            child: SquareTile(
                                imagePath:
                                    'lib/images/Facebook_Logo_(2019).png')))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Future getUser(String uid) async {
//   print(uid);
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .get()
//       .then((value) {
//     //json to model
//     print('User: ${value['username']}');
//   });
// }

Future signUp(String email, String password, String username,
    BuildContext context) async {
  try {
    showDialog(
        context: context,
        builder: (context) => Center(
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
      await createUser(email, password, username);
      await CacheManager.saveData('email', email);
      await CacheManager.saveData('password', password);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppLayout()),
          (route) => false);
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
    print(e);
  }
}
