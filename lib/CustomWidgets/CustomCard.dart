import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/Models/ResultModel.dart';
import 'package:trial1/Screens/Results.dart';

import 'custom_image_view.dart';

Widget buildCard({
  required String title,
  required String description,
  required String text,
  required String date,
  required String urlImage,
  String? Status,
  required BuildContext context,
}) {
  final double radius = 22;
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
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
        Expanded(child: buildText(context, title, description, date, Status)),
      ],
    ),
  );
}

Widget buildText(BuildContext context, String title, String description,
    String date, String? Status) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Padding(
    padding: EdgeInsets.only(left: width * 0.02),
    child: Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
          ),
          //const SizedBox(height: 8),
          // Text(
          //   description,
          //   style: TextStyle(fontSize: 15),
          // ),
          // const SizedBox(height: 8),
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
              } else if (title == "Normal") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(normalResult)));
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
              const Text(
                "Status: ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                Status ?? "Pending",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w400,
                  color: Status == "true"
                      ? Colors.green
                      : Status == "false"
                          ? Colors.red
                          : Colors.grey,
                ),
              ),
              SizedBox(
                width: width * 0.07,
              ),
              Text(
                date,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
