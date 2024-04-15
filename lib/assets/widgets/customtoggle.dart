import 'package:flutter/material.dart';

import '../theme.dart'; // Import your AppTheme

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: label != null
          ? Text(label!, style: const TextStyle(color: AppTheme.darkText))
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.secondaryColor,
      inactiveThumbColor: AppTheme.grey,
      inactiveTrackColor: AppTheme.darkGrey
          .withOpacity(0.5), // Adjust opacity for inactive state
    );
  }
}
