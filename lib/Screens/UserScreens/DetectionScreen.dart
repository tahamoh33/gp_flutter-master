import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../Models/eye_condition.dart';
//import 'package:sizer/sizer.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

File? _image;
final picker = ImagePicker();

class _DetectionScreenState extends State<DetectionScreen> {
  bool _loading = true;
  List<EyeCondition> eyeConditions = [];
  bool _waiting = true;
  String imgUrl = "";
  String prediction = "";

  @override
  initState() {
    super.initState();
    _loading = true;
    _waiting = true;
  }

  Future<void> pickImageFromGallery() async {
    _loading = true;
    _waiting = true;
    prediction = "";
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    await uploadImageToFirebase(_image!);
    //await classifyImage(_image!);
    await sendImage(_image!);
  }

  List<EyeCondition> parseEyeConditions(String responseBody) {
    final parsed = jsonDecode(responseBody);
    List<EyeCondition> eyeConditions = [];
    parsed.forEach((key, value) {
      eyeConditions
          .add(EyeCondition(name: key, confidence: value['confidence']));
    });
    return eyeConditions;
  }

  Future<void> sendImage(File image) async {
    final url = Uri.parse('http://192.168.1.3:8080/predict');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    _waiting = true;
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        eyeConditions = parseEyeConditions(response.body);
        // take the highest confidence from the list
        final result = eyeConditions
            .reduce(
                (curr, next) => curr.confidence > next.confidence ? curr : next)
            .name
            .split('_');
        prediction = result[0];
        storeImageInfoInFirestore(imgUrl, image.path, result[0]);
        _waiting = false;
      });
    } else {
      throw Exception('Failed to connect to API');
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    _loading = false;
    //Upload image to firebase
    String filename = basename(image.path);
    await FirebaseStorage.instance
        .ref()
        .child('uploads/ $filename')
        .putFile(image)
        .then((value) => (value.ref.getDownloadURL()).then((value) {
              imgUrl = value;
            }));
    return imgUrl;
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
      'status': 'pending'
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          // leading:IconButton(
          //   onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));},
          //   icon: Icon(Icons.arrow_back_sharp),
          // ),
          centerTitle: true,
          title: Text(
            "Check your eyes",
            style: TextStyle(fontSize: 25, color: Theme.of(context).hintColor),
          )),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Upload Image",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Upload Your Traditional Funds Photography to check your eye disease \n \n Image Example :",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
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
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            child: Center(
                              child: Container(
                                child: _loading == true
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          "lib/images/1_right.png",
                                          fit: BoxFit.fill,
                                          width: width * 0.6,
                                          height: height * 0.3,
                                        ),
                                      ) //show nothing if no picture selected
                                    : Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: _waiting == true
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Image.file(
                                                    _image!,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              prediction,
                                              //'The object is: ${_output![0]['label']}!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.2,
                                vertical: height * 0.01),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: Theme.of(context).hintColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.1,
                                      vertical: height * 0.017),
                                ),
                                onPressed: () async {
                                  await pickImageFromGallery();
                                  showModalBottomSheet(
                                    isDismissible: true,
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.7,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: Text(
                                                prediction,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: eyeConditions.length,
                                                itemBuilder: (context, index) {
                                                  final eyeCondition =
                                                      eyeConditions[index];
                                                  return ListTile(
                                                    title:
                                                        Text(eyeCondition.name),
                                                    subtitle: Text(
                                                        'Confidence: ${eyeCondition.confidence}'),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text("Upload")),
                          ),
                        ])),
              ]),
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   icon: Icons.add,
      //   activeIcon: Icons.close,
      //   backgroundColor: Theme.of(context).hintColor,
      //   activeBackgroundColor: Colors.deepPurpleAccent,
      //   //background color when menu is expanded
      //   visible: true,
      //   closeManually: false,
      //   curve: Curves.bounceIn,
      //   overlayColor: Colors.black,
      //   overlayOpacity: 0.5,
      //
      //   elevation: 8.0,
      //   //shadow elevation of button
      //
      //   children: [
      //     SpeedDialChild(
      //       child: Icon(Icons.image, color: Colors.white),
      //       backgroundColor: Colors.lightBlue,
      //       label: 'Add from gallery',
      //       labelStyle: TextStyle(fontSize: 18.0),
      //       onTap: pickImageFromGallery,
      //     ),
      //   ],
      // ),
    );
  }
}
