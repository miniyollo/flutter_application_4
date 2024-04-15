import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../assets/theme.dart';
import '../../assets/widgets/customalert.dart';
import '../../assets/widgets/customsearchbar.dart';
import '../../database/contactdb.dart';
import '../../database/model/emergencycontact.dart';

// Import your reusable widgets and SQLite helper here
// import 'reusable_search_bar.dart';
// import 'text_icon_card.dart';
// import 'xxlarge_circular_button.dart';
// import 'your_sqlite_helper.dart';

class AllContactsPage extends StatefulWidget {
  const AllContactsPage({super.key});

  @override
  _AllContactsPageState createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Contact> filteredContacts = [];
  Future<void> askPermission() async {
    PermissionStatus permissionStatus = await getContactPermission();
    // Fluttertoast.showToast(msg: "Contact Permission Status: $permissionStatus");
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermission(permissionStatus, context);
    }
  }

  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  List<Contact> contacts = [];
  void getAllContacts() async {
    try {
      List<Contact> _contacts =
          await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        contacts = _contacts;
        filteredContacts = _contacts;
      });
      // Fluttertoast.showToast(msg: "Fetched ${_contacts.length} contacts");
    } catch (e) {
      // Fluttertoast.showToast(msg: "Failed to fetch contacts: $e");
      print(e); // Also print the error to the console for detailed debugging.
    }
  }

  void filterContacts(String query) {
    // Check if the search query is empty
    if (query.isEmpty) {
      setState(() {
        filteredContacts =
            contacts; // Show all contacts if search query is empty
      });
    } else {
      // If there's a search query, filter the contacts
      final List<Contact> _filteredContacts = contacts.where((contact) {
        final String? contactName = contact.displayName ?? contact.familyName;
        final String searchLower = query.toLowerCase();
        return contactName?.toLowerCase().contains(searchLower) ?? false;
      }).toList();

      setState(() {
        filteredContacts = _filteredContacts;
      });
    }
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    askPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Contacts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ReusableSearchBar(
            onSearch: (query) => filterContacts(query),
          ),
        ),
      ),
      body: contacts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = filteredContacts[index];
                return ListTile(
                  title: Text(contact.displayName ??
                      contact.familyName ??
                      (contact.phones != null && contact.phones!.isNotEmpty
                          ? contact.phones!.first.value
                          : 'No Name Available')!),
                  // title: Text(contact.familyName ??
                  //     contact.displayName ??
                  //     contact.familyName ??

                  //     'No Name Available'),
                  subtitle: Text(contact.company ?? 'No Company'),
                  leading: CircleAvatar(
                      backgroundColor: AppTheme
                          .nearlyDarkRed, // Specify a background color for the icon
                      backgroundImage:
                          contact.avatar != null && contact.avatar!.isNotEmpty
                              ? MemoryImage(contact.avatar!)
                              : null,
                      child: contact.avatar != null &&
                              contact.avatar!.isNotEmpty
                          ? null // If you have an avatar, show it as a backgroundImage instead.
                          : Text(contact.initials())),
                  onTap: () {
                    if (contact.phones!.length > 0) {
                      final String phoneNum =
                          contact.phones!.elementAt(0).value!;
                      final String name = contact.displayName!;
                      _addContact(EmergencyContact(phoneNum, name));
                    } else {
                      // Fluttertoast.showToast(
                      //     msg: "Failed to add contact as it doesnt exist");
                    }
                  },
                );
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to the page where a new contact can be added
      //   },
      //   backgroundColor: AppTheme.secondaryColor,
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void _addContact(EmergencyContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      // Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      // Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}

void handleInvalidPermission(
    PermissionStatus permissionStatus, BuildContext context) {
  if (permissionStatus == PermissionStatus.denied) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Contact Permission",
          message:
              "This app requires contact access to function properly. Please allow access in your settings.",
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Settings"),
              onPressed: () {
                openAppSettings(); // Open app settings for the user to change permission settings
              },
            ),
          ],
        );
      },
    );
  }
  // Handle other permission statuses if necessary
}
