import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Custom_Title({
  required String word,

})=> Text
  (
  word,
  style: TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 20,
    fontFamily: "@font/montserrat_semibold",
    decorationColor: Colors.black,
    color: Colors.blue,
  ),
);
