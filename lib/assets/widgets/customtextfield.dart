// ignore: file_names
import 'package:flutter/material.dart';

import '../theme.dart';




bool showOTP = false;

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? icon;
  final IconData? suffixIcon;

  final String? Function(String?)? validator; // Optional validator function

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: AppTheme.nearlyWhite,
        errorText: validator != null
            ? validator!(controller.text)
            : null, // Display error message from validator
      ),
      style: const TextStyle(
        color: AppTheme.nearlyDarkRed,
        fontFamily: AppTheme.fontName,
      ),
      validator: validator, // Pass validator function to Form validation
    );
  }
}