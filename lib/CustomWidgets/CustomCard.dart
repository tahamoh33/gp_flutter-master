import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trial1/Screens/Models/ResultModel.dart';

import '../Screens/UserScreens/Results.dart';
import 'custom_image_view.dart';

Widget buildCard({
  required String title,
  required String description,
  required String text,
  required String date,
  required String urlImage,
  required String docID,
  String? Status,
  required BuildContext context,
}) {
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
            child: buildText(context, title, description, date, docID, Status)),
      ],
    ),
  );
}

Widget buildText(BuildContext context, String title, String description,
    String date, String docID, String? Status) {
  final width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(left: width * 0.02),
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width*0.3,
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
                            builder: (context) => Results(glaucomaResult, docID)));
                  } else if (title == "Diabetic") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Results(diabeticResult, docID)));
                  } else if (title == "Cataract") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Results(cataractResult, docID)));
                  } else if (title == "Normal") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Results(normalResult, docID)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: const Text('See more',
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
