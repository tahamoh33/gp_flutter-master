import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Constants/string_manager.dart';
import 'package:trial1/Screens/NavigationScreens/AppLayout.dart';

import '../cache_manager.dart';

class SignupPage extends StatefulWidget {

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _email =  TextEditingController();
  final _password =  TextEditingController();
  final _confirmPassword =  TextEditingController();
  final _username =  TextEditingController();

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

  Future signUp(String email, String password, String username,
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: SafeArea(
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
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dialogBackgroundColor,
                        hintText: 'Email Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        prefixIcon: const Icon(Icons.email_rounded),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    TextField(
                      controller: _username,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dialogBackgroundColor,
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person_2_outlined),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    TextField(
                      controller: _password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dialogBackgroundColor,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    TextField(
                      controller: _confirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dialogBackgroundColor,
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
                    SizedBox(height: height * 0.015),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.blue,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked = newBool!;
                      });
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                      "Terms & Conditions"),
                                  content: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
"By accessing or using the Application, you agree that you have read, understand and agree to be bound by these Terms & Conditions of Use, as amended from time to time.Please note the information contained on the Application is for general guidance only, And The Application made by CS students for academic purpose.The Application is not intended to offer medical advice, Always seek the advice of your physician or other qualified health care provider prior to starting any new treatment, or if you have any questions regarding symptoms or a medical condition."
                                      ),


                                  ),
                              actions: [
                                Center(
                                  child: CustomButton(label: "I Accept", onPressed: (){
                                    setState(() {
                                      isChecked=true;
                                    });
                                  }),
                                )
                              ],
                        )
                        );
                      },
                      child: Text("Agree to terms and conditions"))
                ]),

                SizedBox(
                  height: height * 0.02,
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
                      else if(isChecked==false){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please check to terms and conditions'),
                            backgroundColor: Colors.red,
                          ),
                        );

                        return;
                      }
                      await signUp(email, password, username, context);
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
                    Container(
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
                                        builder: (context) => AppLayout()),
                                    (route) => false);
                              }).catchError((e) {
                                print(e);
                                // Handle sign-in error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                            },
                            child: SquareTile(
                                imagePath:
                                    'lib/images/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png'))),
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
