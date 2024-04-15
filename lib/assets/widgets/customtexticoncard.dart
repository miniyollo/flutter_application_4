import 'package:flutter/material.dart';

import '../theme.dart'; // Make sure to import your AppTheme

class TextIconCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const TextIconCard({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shadowColor: AppTheme.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 60,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: AppTheme.body2),
                Icon(
                  icon,
                  color: AppTheme.nearlyDarkRed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
