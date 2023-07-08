import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.onChanged,
      this.onTap,
      this.validator});

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? autofocus;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;
  void Function(String)? onChanged;
  void Function()? onTap;
  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        controller: controller,
        autofocus: autofocus!,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setHintFontStyle(),
      labelStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setHintFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.MontserratRomanRegular16Dark:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
        );
      case TextFormFieldFontStyle.MontserratRomanRegular14:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
        );
      default:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.MontserratRomanRegular14:
        return const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        );
      case TextFormFieldFontStyle.MontserratRomanRegular14White:
        return const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        );
      case TextFormFieldFontStyle.MontserratRomanRegular16Dark:
        return TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(
          5.00,
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.UnderLineGray40001:
        return const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      default:
        return Colors.white;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.UnderLineGray40001:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT12:
        return const EdgeInsets.only(
          top: 12,
          right: 12,
          bottom: 12,
        );
      default:
        return const EdgeInsets.only(
          top: 12,
          bottom: 12,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder5,
}

enum TextFormFieldPadding {
  PaddingT12,
  PaddingT12_1,
}

enum TextFormFieldVariant {
  None,
  OutlineGray300,
  UnderLineGray40001,
}

enum TextFormFieldFontStyle {
  MontserratRomanRegular16Dark,
  MontserratRomanRegular14White,
  MontserratRomanRegular16,
  MontserratRomanRegular14,
}
