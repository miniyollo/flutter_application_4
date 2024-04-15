import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../assets/widgets/customtexticoncard.dart';

class SafePlacesPage extends StatefulWidget {
  @override
  _SafePlacesPageState createState() => _SafePlacesPageState();
}

class _SafePlacesPageState extends State<SafePlacesPage> {
  final List<Map<String, dynamic>> safePlaces = [
    {'name': 'Police Station', 'icon': Icons.local_police},
    {'name': 'Hospital', 'icon': Icons.local_hospital},
    {'name': 'Fire Station', 'icon': Icons.local_fire_department},
    {'name': 'Pharmacy', 'icon': Icons.local_pharmacy},
  ];

  final TextEditingController _controller = TextEditingController();

  Future<void> _launchMapsSearch(String query) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addLocation() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        safePlaces.add({'name': _controller.text, 'icon': Icons.place});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add New Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addLocation,
                ),
              ),
              onSubmitted: (_) => _addLocation(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: safePlaces.length,
              itemBuilder: (context, index) {
                final place = safePlaces[index];
                return TextIconCard(
                  text: place['name'],
                  icon: place['icon'],
                  onTap: () => _launchMapsSearch('${place['name']} near me'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
