import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tflite/tflite.dart';
import 'package:trial1/Screens/NavigationScreens/Home.dart';

import '../../CustomWidgets/customFile.dart';
//import 'package:sizer/sizer.dart';

class DetectionScreen extends StatefulWidget {
  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

bool _loading = true;
File? _image;
List? _output;
String url = "";
final picker = ImagePicker();

class _DetectionScreenState extends State<DetectionScreen> {
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    // show loading indicator while waiting for image classification
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 4,
      imageStd: 255,
      imageMean: 0,
    );
    setState(() {
      _output = output;
      _loading = false;
      storeImageInfoInFirestore(url, image.path, _output![0]['label']);
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/Labels.txt");
  }

  pickImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    await uploadImageToFirebase(_image!);
    await classifyImage(_image!);
  }

  Future<String> uploadImageToFirebase(File image) async {
    //Upload image to firebase
    String filename = basename(image.path);
    await FirebaseStorage.instance
        .ref()
        .child('uploads/ $filename')
        .putFile(image)
        .then((value) => (value.ref.getDownloadURL()).then((value) {
              url = value;
            }));
    return url;
  }

  Future storeImageInfoInFirestore(
      String imageUrl, String imagePath, String predictionLabel) async {
    // Access the Firestore collection for storing predictions
    CollectionReference predictionsCollection =
        FirebaseFirestore.instance.collection('predictions');

    // Create a new document and set the fields
    await predictionsCollection.add({
      'timestamp': DateTime.now(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'predictionLabel': predictionLabel,
    });
  }

  bool isBottomFormshown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          leading:IconButton(
            onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));},
            icon: Icon(Icons.arrow_back_sharp),
          ),
        centerTitle: true,
        title:  Text("Check your eyes",
          style: TextStyle(
            fontSize: 25,
                color: Colors.blue
          ), )

      ),

      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Upload Image",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(
                  height: 30,
                ),
                Text("Upload Your Traditional Funds Photography to check your eye disease \n \n Image Example :",
                  style: TextStyle(
                    fontSize: 16,
                        fontWeight: FontWeight.w500,

                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Container(
                              child: Center(
                                child: _loading == true
                                    ? Container(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          child: Image.asset(
                                            "lib/images/1_right.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                )//show nothing if no picture selected
                                    : Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          _output != null
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Text(
                                                    'The object is: ${_output![0]['label']}!',
                                                    style: TextStyle(
                                                        color: Theme.of(context).hintColor,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ])),
              ]),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).hintColor,
        activeBackgroundColor: Colors.deepPurpleAccent,
        //background color when menu is expanded
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,

        elevation: 8.0,
        //shadow elevation of button

        children: [
          SpeedDialChild(
            child: Icon(Icons.image, color: Colors.white),
            backgroundColor: Colors.lightBlue,
            label: 'Add from gallery',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: pickImageFromGallery,
          ),
        ],
      ),
    );
  }
}
