import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../assets/widgets/customtexticoncard.dart';

Future<void> _launchMapsSearch(String query) async {
  final Uri url =
      Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SafePlacesPage extends StatelessWidget {
  SafePlacesPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> safePlaces = [
    {'name': 'Police Station', 'icon': Icons.local_police},
    {'name': 'Hospital', 'icon': Icons.local_hospital},
    {'name': 'Fire Station', 'icon': Icons.local_fire_department},
    {'name': 'Pharmacy', 'icon': Icons.local_pharmacy},
    // Add more safe places as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: safePlaces.length,
        itemBuilder: (context, index) {
          final place = safePlaces[index];
          return TextIconCard(
            text: place['name'],
            icon: place['icon'],
            onTap: () => _launchMapsSearch('${place ['name']} near me'),
            // onTap is optional, not providing it since these are informational
          );
        },
      ),
    );
  }
}
