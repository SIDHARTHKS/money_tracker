import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/view/widget/text/app_text.dart';
import '../../../helper/color_helper.dart'; // adjust path if needed

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final double fontSize;
  final bool obscureText;
  final int maxLines;
  final FocusNode? focusNode; // <-- optional FocusNode added

  const CommonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.fillColor,
    this.fontSize = 15,
    this.obscureText = false,
    this.maxLines = 1,
    this.focusNode, // <-- optional FocusNode parameter
  });

  @override
  Widget build(BuildContext context) {
    final colorHelper = AppColorHelper();

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      focusNode: focusNode, // <-- set focusNode here
      style: textStyle(fontSize, colorHelper.primaryTextColor, FontWeight.w400),
      decoration: InputDecoration(
        hintText: label,
        labelText: "",
        hintStyle: textStyle(
            fontSize,
            colorHelper.primaryTextColor.withValues(alpha: 0.5),
            FontWeight.w400),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorHelper.primaryTextColor)
            : null,
        filled: true,
        fillColor:
            fillColor ?? colorHelper.primaryColor.withValues(alpha: 0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorHelper.borderColor.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorHelper.primaryColor.withValues(alpha: 0.05),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
