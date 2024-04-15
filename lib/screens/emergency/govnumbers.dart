import 'package:flutter/material.dart';
// Import your theme if needed for styles
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../assets/theme.dart';
import '../../assets/widgets/customtexticoncard.dart';

class GovContactsPage extends StatelessWidget {
  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  GovContactsPage({super.key});

  final List<Map<String, dynamic>> emergencyServices = [
    {
      'name': 'Ambulance',
      'icon': Icons.local_hospital,
      'number': '9405660280'
    },
    {'name': 'Police', 'icon': Icons.local_police, 'number': '08592119YYYY'},
    {
      'name': 'Fire Brigade',
      'icon': Icons.local_fire_department,
      'number': '08592119ZZZZ'
    },
    // Add more services with their numbers
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Emergency Contacts",
                style: TextStyle(
                  fontSize: 24.0, // Example font size
                  fontWeight: FontWeight.bold,
                  color: AppTheme
                      .darkText, // Ensure your theme has this or replace with a direct color
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: emergencyServices.length,
                itemBuilder: (context, index) {
                  final service = emergencyServices[index];
                  return TextIconCard(
                    text: service['name'],
                    icon: service['icon'],
                    onTap: () => _callNumber(service['number']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
