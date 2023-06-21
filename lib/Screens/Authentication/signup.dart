import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/CustomWidgets/square_tile.dart';
import 'package:trial1/Screens/Constants/string_manager.dart';
import 'package:trial1/Screens/NavigationScreens/AppLayout.dart';
import 'package:trial1/Screens/NavigationScreens/welcome.dart';
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
  bool isChecked=false;
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
                MaterialPageRoute(builder: ((context) => WelcomeScreen())));
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
                    value: isChecked,
                    activeColor: Colors.blue,
                    onChanged: (newBool) {
                      setState(() {
                        isChecked=newBool!;
                      });
                    },
                  ),
                  TextButton(onPressed: (){
                    showDialog(context: context, builder: (context) => AlertDialog(
                    title:const Text("Agree to terms and conditions"),
                      content:SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                          child: Text("Please read these terms and conditions (terms and conditions, terms) carefully before using Eye diseases classification app .Conditions of useBy using this website, you certify that you have read and reviewed this Agreement and that you agree to comply with its terms. If you do not want to be bound by the terms of this Agreement, you are advised to stop using the website accordingly. We only grants use and access of this website, its products, and its services to those who have accepted its terms.Privacy policyBefore you continue using our website, we advise you to read our privacy policy regarding our user data collection. It will help you better understand our practices.Age restrictionYou must be at least 18 (eighteen) years of age before you can use this website. By using this website, you warrant that you are at least 18 years of age and you may legally adhere to this Agreement. We assume no responsibility for liabilities related to age misrepresentation.Intellectual propertyYou agree that all materials, products, and services provided on this website are the property, its affiliates, directors, officers, employees, agents, suppliers, or licensors including all copyrights, trade secrets, trademarks, patents, and other intellectual property. You also agree that you will not reproduce or redistribute , intellectual property in any way, including electronic, digital, or new trademark registrations.You grant a royalty-free and non-exclusive license to display, use, copy, transmit, and broadcast the content you upload and publish. For issues regarding intellectual property claims, you should contact the company in order to come to an agreement.User accountsAs a user of this website, you may be asked to register with us and provide private information. You are responsible for ensuring the accuracy of this information, and you are responsible for maintaining the safety and security of your identifying information. You are also responsible for all activities that occur under your account or password.If you think there are any possible issues regarding the security of your account on the website, inform us immediately so we may address them accordingly.We reserve all rights to terminate accounts, edit or remove content and cancel orders at our sole discretion.Applicable lawBy using this website, you agree that the laws of the [your location], without regard to principles of conflict laws, will govern these terms and conditions, or any dispute of any sort that might come between and you, or its business partners and associates.DisputesAny dispute related in any way to your use of this website or to products you purchase from us shall be arbitrated by state or federal court [your location] and you consent to exclusive jurisdiction and venue of such courts.IndemnificationYou agree to indemnify and its affiliates and hold  harmless against legal claims and demands that may arise from your use or misuse of our services. We reserve the right to select our own legal counsel.Limitation on liabilityWe are not liable for any damages that may occur to you as a result of your misuse of our website.We reserve the right to edit, modify, and change this Agreement at any time. We shall let our users know of these changes through electronic mail. This Agreement is an understanding between [company name] and the user, and this supersedes and replaces all prior agreements regarding the use of this website.")) ,

                    ) );
                  }, child: Text("Agree to terms and conditions"))

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
