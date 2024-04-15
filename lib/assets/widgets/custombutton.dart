import 'package:flutter/material.dart';

import '../theme.dart'; // Make sure to import your AppTheme

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? iconData; // Optional icon data

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppTheme.secondaryColor, // Use your theme's secondary color
    this.textColor = AppTheme.nearlyWhite, // Use a contrasting color for text
    this.iconData, // Icon data is nullable, making it optional
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: iconData != null ? Icon(iconData, color: textColor) : Container(), // Show icon if provided
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: AppTheme.fontName,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adjust padding
      ),
    );
  }
}
