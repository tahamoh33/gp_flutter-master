import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'Models/ResultModel.dart';
import 'State Management/selected_page_provider.dart';

class Results extends StatefulWidget {
  final ResultModel resultModel;
  Results(this.resultModel);
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final selectedPageProvider = Provider.of<SelectedPageProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Results",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).hintColor,
              fontFamily: "Montserrat",
            ),
          )),
      body: SingleChildScrollView(
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
            ExpansionTile(
              //collapsedBackgroundColor: Colors.white,
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              //backgroundColor: Colors.blue,
              //controlAffinity: ListTileControlAffinity.leading,
              tilePadding: const EdgeInsets.fromLTRB(25, 0, 200, 0),
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
            SizedBox(
              height: height * 0.01,
            ),
            ExpansionTile(
              tilePadding: const EdgeInsets.fromLTRB(25, 0, 100, 0),
              childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              //controlAffinity: ListTileControlAffinity.leading,
              title: Text('Symptoms of ${widget.resultModel.disease}',
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
            SizedBox(
              height: height * 0.01,
            ),
            ExpansionTile(
              tilePadding: const EdgeInsets.fromLTRB(25, 0, 50, 0),
              childrenPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              //controlAffinity: ListTileControlAffinity.leading,
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
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
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Return to history",
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
    );
  }
}
