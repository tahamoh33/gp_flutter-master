import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trial1/CustomWidgets/custom_button.dart';
import 'package:trial1/Screens/Authentication/Login.dart';

class Forgotpw extends StatefulWidget {
  const Forgotpw({super.key});

  @override
  State<Forgotpw> createState() => _Forgotpw();
}

class _Forgotpw extends State<Forgotpw> {
  FirebaseAuth instance = FirebaseAuth.instance;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password Reset link is sent ! , check your email "),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      //print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const Login())));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text("Please enter your email to reset password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "monterrsant",
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 53.0,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                labelText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_outline_sharp),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: CustomButton(
                label: 'Reset password',
                onPressed: passwordReset,
                width: 200,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
