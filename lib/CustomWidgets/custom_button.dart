import 'package:flutter/material.dart';
import 'package:trial1/Screens/Constants/color_manager.dart';

class CustomButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  double? width;
  double? height;
  CustomButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(primary: ColorManager.primary),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
