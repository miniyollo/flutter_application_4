import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


import 'package:sqflite/sqflite.dart';

import '../../assets/theme.dart';
import '../../assets/widgets/customsearchbar.dart';
import '../../database/contactdb.dart';
import '../../database/model/emergencycontact.dart';
import 'contact_screen.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<EmergencyContact>? contactlist = [];
  int count = 0;

  void showList() {
    Future<Database> dbFuture = databaseHelper.initilizeDatabase();
    dbFuture.then((value) {
      Future<List<EmergencyContact>> contactListFuture =
          databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactlist = value;
          this.count = value.length;
        });
      });
      return null;
    });
  }

  void deleteContact(EmergencyContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      // Fluttertoast.showToast(msg: "contact removed succesfully");
      showList();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    if (contactlist == null) {
      contactlist = [];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ReusableSearchBar(
            onSearch: (query) {
              // Implement search functionality if needed
            },
          ),
        ),
      ),
      // The body of the Scaffold
      body: contactlist!.isEmpty
          ? const Center(
              child: Text("No contacts saved!"),
            )
          : Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    // This wraps the ListView to avoid unbounded height errors
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: count,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              // Populate your ListTile with actual data here
                              title: Text(contactlist![index].name),
                              // title: Text(
                              //   contactlist![index].number.isNotEmpty
                              //       ? contactlist![index].number
                              //       : (contactlist![index].name.isNotEmpty
                              //           ? contactlist![index].name
                              //           : (contactlist![index].name.isNotEmpty
                              //               ? contactlist![index].name
                              //               : 'No Contact Info')),
                              // ),

                              trailing: Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await FlutterPhoneDirectCaller
                                              .callNumber(
                                                  contactlist![index].number);
                                        },
                                        icon: Icon(Icons.call)),
                                    IconButton(
                                      onPressed: () {
                                        deleteContact(contactlist![index]);
                                      },
                                      icon: Icon(Icons.delete),
                                      color: AppTheme.nearlyDarkRed,
                                    ),
                                  ],
                                ),
                              ), // Example title
                              // Add more properties to ListTile as needed
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Other widgets can go here
                ],
              ),
            ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllContactsPage(),
              ));

          if (result == true) {
            showList();
          }
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
