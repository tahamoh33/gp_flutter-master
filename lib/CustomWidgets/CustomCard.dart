import 'package:flutter/material.dart';
import 'package:trial1/Screens/Models/ResultModel.dart';
import 'package:trial1/Screens/Results.dart';

Widget buildCard({
  required String title,
  required String description,
  required String text,
  required String date,
  required String urlImage,
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
        buildImage(radius, urlImage),
        Expanded(child: buildText(context, title, description, date)),
      ],
    ),
  );
}

Widget buildImage(double radius, String urlImage) => ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        urlImage,
        fit: BoxFit.cover,
        width: 130,
        height: 130,
      ),
    );
Widget buildText(
        BuildContext context, String title, String description, String date) =>
    Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              }
            },
            child: const Text('See more',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                )),
          ),
          Text(
            date,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
