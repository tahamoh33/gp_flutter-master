import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Models/ResultModel.dart';

class Results extends StatefulWidget {
  final ResultModel resultModel;
  final String docID;
  const Results(this.resultModel, this.docID, {super.key});
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final commentController = TextEditingController();

  void getComment(String docId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('predictions')
        .doc(docId)
        .get();
    if (userDoc.exists) {
      final userdata = userDoc.data() as Map<String, dynamic>;
      setState(() {
        try {
          commentController.text = userdata['comment'];
        } catch (e) {
          commentController.text = 'Not Available Yet';
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComment(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Results",
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).hintColor,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                width: width * 0.9,
                height: height * 0.07,
                margin: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                child: Text(
                  widget.resultModel.disease,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColorDark),
                ),
              ),
              // SizedBox(
              //   height: height * 0.001,
              // ),
              ExpansionTile(
                //collapsedBackgroundColor: Colors.white,
                collapsedIconColor: Theme.of(context).primaryColorDark,
                iconColor: Theme.of(context).primaryColorDark,
                //backgroundColor: Colors.blue,
                //controlAffinity: ListTileControlAffinity.leading,
                tilePadding: const EdgeInsets.fromLTRB(25, 0, 190, 0),
                childrenPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                //expandedAlignment: Alignment.topLeft,
                //expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text('Description',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                children: [
                  ListTile(
                    title: Text(
                      widget.resultModel.description,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(25, 0, 190, 0),
                childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                collapsedIconColor: Theme.of(context).primaryColorDark,
                iconColor: Theme.of(context).primaryColorDark,
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                //controlAffinity: ListTileControlAffinity.leading,
                title: Text('Symptoms',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                children: [
                  ListTile(
                    title: Text(
                      widget.resultModel.symptom,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(25, 0, 90, 0),
                childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                //controlAffinity: ListTileControlAffinity.leading,
                collapsedIconColor: Theme.of(context).primaryColorDark,
                iconColor: Theme.of(context).primaryColorDark,
                title: Text('When to get medical advice',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                children: [
                  ListTile(
                    title: Text(
                      widget.resultModel.medicalAdvice,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: const EdgeInsets.fromLTRB(25, 0, 100, 0),
                childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                collapsedIconColor: Theme.of(context).primaryColorDark,
                iconColor: Theme.of(context).primaryColorDark,
                title: Text('Doctor\'s comment',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                children: [
                  ListTile(
                    title: Text(
                      commentController.text,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Return to history?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).hintColor,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
