import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../CustomWidgets/CustomCard.dart';

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
          return const Center(child: CircularProgressIndicator());
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
                data['timestamp'].toDate().add(const Duration(hours: 1));
            String formattedDate = DateFormat('MMMM d, yyyy').format(myDate);
            return Column(children: [
              buildCard(
                urlImage: data['imageUrl'],
                title: data['predictionLabel'],
                date: formattedDate,
                //'${myDate.toString().substring(0, 10)} ${DateFormat.jm().format(myDate)}',
                description: '...',
                docID: document.id,
                text: 'See more',
                Status: data['status'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          // leading:IconButton(
          //   onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>DetectionScreen()));},
          //   icon: Icon(Icons.arrow_back_sharp),
          // ),
          title: Text(
            "History",
            style: TextStyle(fontSize: 25, color: Theme.of(context).hintColor),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: buildPredictionList(FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }
}
