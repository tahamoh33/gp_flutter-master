import 'package:flutter/material.dart';
import 'package:trial1/Screens/Constants/color_manager.dart';

class CustomTextField extends StatelessWidget {
  String label;
  IconData prefixIcon;
  IconData? suffixIcon;
  bool? isPassword;
  VoidCallback? suffixPressed;

  CustomTextField(
      {super.key,
      required this.label,
      required this.prefixIcon,
      this.suffixIcon,
      this.suffixPressed,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: isPassword!,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.primaryLight,
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffixIcon),
              )
            : null,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.gray, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
