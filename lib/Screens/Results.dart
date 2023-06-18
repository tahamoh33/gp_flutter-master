import 'package:flutter/material.dart';

import 'Models/ResultModel.dart';

class Results extends StatelessWidget {
  final ResultModel resultModel;
  Results(this.resultModel); // bool _isShow = false;
  // late final bool _customIcon = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //margin: EdgeInsets.fromLTRB(0, , 0, 15),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: InkWell(
                      splashColor: Color.fromARGB(66, 82, 81, 81),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink.image(
                        image: AssetImage('lib/images/arrowleft.png'),
                        width: 25,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 85,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: 77,
                      height: 24,
                      child: Text(
                        "Results",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Color(0xff1a74d7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: 72.0,),
            Container(
              width: 97,
              height: 22,
              margin: EdgeInsets.fromLTRB(25, 20, 15, 0),
              child: Text(
                resultModel.disease,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            ExpansionTile(
              //collapsedBackgroundColor: Colors.white,
              //collapsedIconColor: Colors.black26,
              iconColor: Colors.black38,
              //backgroundColor: Colors.blue,
              //controlAffinity: ListTileControlAffinity.leading,
              tilePadding: EdgeInsets.fromLTRB(25, 0, 200, 0),
              childrenPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              title: const Text('Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  )),
              children: [
                Container(
                  width: 308,
                  height: 168,
                  child: ListTile(
                    title: Text(
                      resultModel.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.fromLTRB(25, 0, 100, 0),
              childrenPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              //controlAffinity: ListTileControlAffinity.leading,
              iconColor: Colors.black38,
              title: Text('Symptoms of ${resultModel.disease}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  )),
              children: [
                Container(
                  width: 308,
                  height: 168,
                  child: ListTile(
                    title: Text(
                      resultModel.symptom,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.fromLTRB(25, 0, 80, 0),
              childrenPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              //controlAffinity: ListTileControlAffinity.leading,
              iconColor: Colors.black38,
              title: const Text('When to get medical advice',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  )),
              children: [
                Container(
                  width: 308,
                  height: 168,
                  child: ListTile(
                    title: Text(
                      resultModel.medicalAdvice,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
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
