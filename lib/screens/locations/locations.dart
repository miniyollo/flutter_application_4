import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SafePlacesPage extends StatefulWidget {
  @override
  _SafePlacesPageState createState() => _SafePlacesPageState();
}

class _SafePlacesPageState extends State<SafePlacesPage> {
  List<Map<String, Object>> safePlaces = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _launchMapsSearch(String query) async {
    final Uri url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadPlaces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? loadedPlaces = prefs.getStringList('savedPlaces');
    if (loadedPlaces != null) {
      setState(() {
        safePlaces = loadedPlaces
            .map((name) => {'name': name, 'icon': Icons.place})
            .toList();
      });
    }
  }

  void _addLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_controller.text.isNotEmpty) {
      setState(() {
        safePlaces.add({
          'name': _controller.text as Object,
          'icon': Icons.place as Object
        });
        prefs.setStringList('savedPlaces',
            safePlaces.map((place) => place['name'] as String).toList());
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
                return ListTile(
                  title: Text(place['name'] as String),
                  leading: Icon(place['icon'] as IconData?),
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
