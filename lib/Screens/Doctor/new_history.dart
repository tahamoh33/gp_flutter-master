import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/CustomWidgets/custom_image_view.dart';
import 'package:trial1/Screens/Doctor/DoctorResults.dart';
import 'package:trial1/helpers/BiggerImage.dart';

import '../Constants/image_constant.dart';
import '../Models/ResultModel.dart';

class Doctorhistory extends StatefulWidget {
  @override
  DoctorhistoryState createState() => DoctorhistoryState();
}

class DoctorhistoryState extends State<Doctorhistory> {
  bool isCorrect = false;
  bool isWrong = false;
  void sendPushMessage(String token) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAEtdM2Ws:APA91bGRO8c43La2FYbhk4cjjColIFw5y8WE3lK7YRJBCf-pBOHqbzWfBqYXu0EzcG5VG2cj0rZpyIzpMNeoI9D4npp_gO9TgtrmlfKQOqmrZX64xiJlv1DGJ6wmpS7ZDRl32SkZA86c',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': 'Your prediction is ready',
                'title': 'A doctor has reviewed your prediction',
                'sound': 'default',
                'android_channel_id': 'high_importance_channel',
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'title': 'A doctor has reviewed your prediction',
                'status': 'done',
                'body': 'Your prediction is ready',
              },
              'to': token,
            },
          ));
    } catch (e) {
      //print(e);
    }
  }

  void confirm(String docId) {
    FirebaseFirestore.instance.collection('predictions').doc(docId).update({
      'status': "true",
    });
  }

  void deny(String docId) {
    FirebaseFirestore.instance.collection('predictions').doc(docId).update({
      'status': "false",
    });
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> buildPredictionList() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('predictions')
          .where('status', isEqualTo: "pending")
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            'No predictions found.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Map<String, dynamic> data = document.data()!;
            DateTime myDate =
                data['timestamp'].toDate().add(const Duration(hours: 1));
            String formattedDate = DateFormat('MMMM d, yyyy').format(myDate);
            return Column(children: [
              buildCard(
                urlImage: data['imageUrl'],
                title: data['predictionLabel'],
                date: formattedDate,
                // '${myDate.toString().substring(0, 10)} ${DateFormat.jm().format(myDate)}
                description: '...',
                text: 'See more',
                docId: document.id,
                Status: data['status'],
                userId: data['uid'],
                context: context,
              ),
              const SizedBox(
                height: 20,
              ),
            ]);
          }).toList(),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Prediction History",
            style: TextStyle(fontSize: 22, color: Theme.of(context).hintColor),
          ),
          // leading: IconButton(
          //   onPressed: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: ((context) => HeyUser())));
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     size: 25,
          //     color: Colors.black,
          //   ),
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: buildPredictionList(),
        ));
  }

  Widget buildCard(
      {required String title,
      required String description,
      required String text,
      required String date,
      required String urlImage,
      required BuildContext context,
      required String docId,
      required String userId,
      String? Status}) {
    const double radius = 22;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 4,
      child: Row(
        children: [
          CustomImageView(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ImagePage(image: urlImage))));
            },
            radius: BorderRadius.circular(radius),
            url: urlImage,
            width: 130,
            height: 130,
          ),
          Expanded(
              child: buildText(
                  context, title, description, date, Status, docId, userId)),
        ],
      ),
    );
  }

  Widget buildText(BuildContext context, String title, String description,
      String date, String? status, String docId, String userId) {
    final width = MediaQuery.of(context).size.width;
    if (status == "pending") {
      isCorrect = false;
      isWrong = false;
    } else if (status == "true") {
      isCorrect = true;
      isWrong = false;
    } else if (status == "false") {
      isCorrect = false;
      isWrong = true;
    }
    return Padding(
      padding: EdgeInsets.only(left: width * 0.02),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.3,
                  child: Text(
                    """a common eye condition that is a cause of blindness worldwide, which""",
                    style: TextStyle(fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (title == "Glaucoma") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DoctorResults(glaucomaResult, docId)));
                    } else if (title == "Diabetic") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DoctorResults(diabeticResult, docId)));
                    } else if (title == "Cataract") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DoctorResults(cataractResult, docId)));
                    } else if (title == "Normal") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DoctorResults(normalResult, docId)));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('See more',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                CustomImageView(
                  svgPath: //isCorrect
                      ImageConstant.checkmarkBlue,
                  // : ImageConstant.checkmarkGray,
                  onTap: () async {
                    DocumentSnapshot snap = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .get();

                    String token = snap['token'];
                    sendPushMessage(token);
                    setState(() {
                      confirm(docId);
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomImageView(
                  svgPath: //isWrong
                      ImageConstant.crossIconRed,
                  //: ImageConstant.crossIconGray,
                  onTap: () async {
                    DocumentSnapshot snap = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .get();
                    String token = snap['token'];
                    //print(token);
                    sendPushMessage(token);
                    setState(() {
                      deny(docId);
                    });
                  },
                ),
                SizedBox(
                  width: width * 0.12,
                ),
                Text(
                  date,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
