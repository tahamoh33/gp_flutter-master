import 'package:flutter/material.dart';
import 'package:trial1/Screens/NavigationScreens/History.dart';

import 'Models/ResultModel.dart';

class Results extends StatelessWidget {
  final ResultModel resultModel;
  Results(this.resultModel); // bool _isShow = false;
  // late final bool _customIcon = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:IconButton(
          onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));},
          icon: Icon(Icons.arrow_back_sharp),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text("Results",
          style: TextStyle(
              fontSize: 25,
              color: Colors.blue,
              fontFamily: "Montserrat",
          ), )

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
