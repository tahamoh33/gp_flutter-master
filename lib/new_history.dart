import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trial1/CustomWidgets/custom_image_view.dart';

import 'Screens/Constants/image_constant.dart';
import 'Screens/Models/ResultModel.dart';
import 'Screens/Results.dart';

class Doctorhistory extends StatefulWidget {
  @override
  DoctorhistoryState createState() => DoctorhistoryState();
}

class DoctorhistoryState extends State<Doctorhistory> {
  bool isCorrect = false;
  bool isWrong = false;
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

      // .where('uid', isEqualTo: userId)
      // .orderBy('timestamp', descending: true)
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            'No predictions found for this user.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Map<String, dynamic> data = document.data()!;
            DateTime myDate =
                data['timestamp'].toDate().add(Duration(hours: 1));
            String formattedDate = DateFormat('MMMM d, yyyy').format(myDate);
            return Column(children: [
              buildCard(
                urlImage: data['imageUrl'],
                title: data['predictionLabel'],
                date:
                    formattedDate, // '${myDate.toString().substring(0, 10)} ${DateFormat.jm().format(myDate)}
                description: '...',
                text: 'See more',
                docId: document.id,
                Status: data['status'],
                context: context,
              ),
              SizedBox(
                height: 20,
              ),
            ]);
          }).toList(),
        );
      },
    );
  }

  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xf5ffcfd),
        leading: IconButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: ((context) => HeyUser())));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: buildPredictionList(),
      ));

  Widget buildCard(
      {required String title,
      required String description,
      required String text,
      required String date,
      required String urlImage,
      required BuildContext context,
      required String docId,
      String? Status}) {
    final double radius = 22;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 4,
      child: Row(
        children: [
          CustomImageView(
            radius: BorderRadius.circular(radius),
            url: urlImage,
            width: 130,
            height: 130,
          ),
          Expanded(
              child:
                  buildText(context, title, description, date, Status, docId)),
        ],
      ),
    );
  }

  Widget buildText(BuildContext context, String title, String description,
      String date, String? status, String docId) {
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
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              if (title == "Glaucoma") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(glaucomaResult)));
              } else if (title == "Diabetic") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(diabeticResult)));
              } else if (title == "Cataract") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(cataractResult)));
              }
            },
            child: const Text('See more',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                )),
          ),
          Row(
            children: [
              CustomImageView(
                svgPath: isCorrect
                    ? ImageConstant.checkmarkBlue
                    : ImageConstant.checkmarkGray,
                onTap: () {
                  setState(() {
                    confirm(docId);
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              CustomImageView(
                svgPath: isWrong
                    ? ImageConstant.crossIconRed
                    : ImageConstant.crossIconGray,
                onTap: () {
                  setState(() {
                    deny(docId);
                  });
                },
              ),
              // Text(
              //   "Status: ",
              //   style: TextStyle(
              //     fontSize: 10,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.grey,
              //   ),
              // ),
              // Text(
              //   "Completed",
              //   style: TextStyle(
              //     fontSize: 10,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.green,
              //   ),
              // ),
              SizedBox(
                width: 40,
              ),
              Text(
                date,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
