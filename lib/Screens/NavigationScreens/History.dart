import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../CustomWidgets/CustomCard.dart';
import '../../CustomWidgets/customFile.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> buildPredictionList(
      String userId) {
    // print(userId);
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('predictions')
          .where('uid', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No predictions found for this user.' ,
            style:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800
            ) ,));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Map<String, dynamic> data = document.data()!;
            DateTime myDate =
                data['timestamp'].toDate().add(Duration(hours: 1));
            return Column(children: [
              buildCard(
                urlImage: data['imageUrl'],
                title: data['predictionLabel'],

                date:
                    '${myDate.toString().substring(0, 10)} ${DateFormat.jm().format(myDate)}',
                description: '...',
                text: 'See more',
                context: context,
              ),
              SizedBox(
                height: 20,
              ),
            ]
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Custom_Title(
            word:"History"
          ),
        )



      ),
      body:  Padding(

        padding: const EdgeInsets.all(20.0),
        child: buildPredictionList(FirebaseAuth.instance.currentUser!.uid),
      ),

    );
  }
}
