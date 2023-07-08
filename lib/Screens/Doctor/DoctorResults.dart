import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Models/ResultModel.dart';

class DoctorResults extends StatefulWidget {
  final ResultModel resultModel;

  final String docId;

  const DoctorResults(this.resultModel, this.docId, {super.key});

  @override
  State<DoctorResults> createState() => _DoctorResultsState();
}

class _DoctorResultsState extends State<DoctorResults> {
  final commentController = TextEditingController();

  void addComment(String docId, String comment) {
    FirebaseFirestore.instance.collection('predictions').doc(docId).update({
      'comment': commentController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Prediction",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).hintColor,
              fontFamily: "Montserrat",
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.03,
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
              SizedBox(
                height: height * 0.005,
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                  child: Text("Description",
                      style: TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.sp),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                    width: 60,
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xff1876d0))),
              ]),
              SizedBox(
                height: height * 0.005,
              ),
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
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  width: 308,
                  height: 228,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x12000000),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 0)
                      ],
                      color: Color(0xfff8f8f8)),
                  child: TextField(
                    controller: commentController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      addComment(widget.docId, commentController.text);
                    },
                    cursorColor: commentController.text.isEmpty
                        ? Colors.grey
                        : Theme.of(context).primaryColorDark,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Write a comment..",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
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
