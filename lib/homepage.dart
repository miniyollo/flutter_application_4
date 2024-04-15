import 'package:flutter/material.dart';


import 'assets/theme.dart';
import 'screens/SendSms/sendsms.dart';
import 'screens/contacts/addnewcont.dart';
import 'screens/emergency/govnumbers.dart';
import 'screens/evidence/captureimage.dart';
import 'screens/locations/locations.dart';
import 'screens/siren/siren.dart';

bool _playAudio = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default index of first screen

  // List of widgets to call on navigation
  final List<Widget> _widgetOptions = [
    SafePlacesPage(),
    GovContactsPage(),
    CameraPage(),
    AddContact(),
    SendSms(),
    SirenPage(),
 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), // Display the selected page
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Gov Contacts',
          ),
        BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Gov Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Add Contact',
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Add Contact',
          ),
             BottomNavigationBarItem(
            icon: Icon(Icons.surround_sound_outlined),
            label: 'sound',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppTheme.nearlyDarkRed,
        onTap: _onItemTapped,
      ),
    );
  }
}
