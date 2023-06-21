import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../CustomWidgets/customFile.dart';

class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

var image;

String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
File? _image;
final picker = ImagePicker();

class _profilescreenState extends State<profilescreen> {
  String url = "";

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();

  var formkey = GlobalKey<FormState>();
  FirebaseAuth instance = FirebaseAuth.instance;
  bool isObsecurepass = true;
  bool ispasswordField = true;

  // Future<String> compressImage(File imageFile) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   final fileName = Path.basename(imageFile.path);
  //
  //   final compressedImage = await FlutterImageCompress.compressAndGetFile(
  //     imageFile.path,
  //     '$path/$fileName.jpg',
  //     quality: 70, // Set the desired image quality here (0 - 100)
  //   );
  //
  //   return compressedImage.path;
  // }

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
    await uploadImageToFirebase(_image!);
    Navigator.pop(context);
  }

  Future getUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(instance.currentUser!.uid) // Replace with the actual user UID
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _email.text = userData['email'];
          _password.text = userData['password'];
          _username.text = userData['username'];
          try {
            url = userData['profilePic'];
          } catch (e) {
            url = "";
          }
        });
      }
    } catch (e) {
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
    url = "";
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,

        title:Custom_Title(word:"Edit profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,

      ),
      body: Form(
        key: formkey,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Center(
                child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage((url != "")
                                        ? url
                                        : "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"))),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0, color: Colors.white),
                          color: Color(0xff1a74d7),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: pickImageFromGallery,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _username,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  //prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Email Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  //prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: ispasswordField ? isObsecurepass : false,
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  suffixIcon: ispasswordField
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isObsecurepass = !isObsecurepass;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          ))
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // TextFormField(
              //   controller: _dateController,
              //   onChanged: (value) {
              //     setState(() {
              //       this.Age = value;
              //     });
              //   },
              //   keyboardType: TextInputType.datetime,
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.grey.shade300,
              //     labelText: 'Date of birth',
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide.none),
              //     //prefixIcon: Icon(Icons.email_rounded),
              //   ),
              // ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final String email = _email.text.trim();
                      final String password = _password.text.trim();
                      final String username = _username.text.trim();
                      await updateUser(instance.currentUser!.uid, email,
                          password, username, url);
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}