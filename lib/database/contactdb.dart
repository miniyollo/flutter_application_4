
import 'package:sqflite/sqflite.dart';

import 'model/emergencycontact.dart';

class DatabaseHelper {
  String contactTable = "contact_table";
  String colId = 'id';
  String colContactName = 'name';
  String colContactNum = 'number';

  DatabaseHelper._createInstace();

  static DatabaseHelper? _databaseHelper;

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstace();
    return _databaseHelper!;
  }

  static Database? _database;
  Future<Database> get database async {
    _database ??= await initilizeDatabase();
    return _database!;
  }

  Future<Database> initilizeDatabase() async {
    String directoryPath = await getDatabasesPath();
    String dbLoc = directoryPath + 'contact.db';

    var contactDatabase =
        await openDatabase(dbLoc, version: 1, onCreate: _createDbTable);
    return contactDatabase;
  }

  void _createDbTable(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $contactTable('
      '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$colContactName TEXT, '
      '$colContactNum TEXT)',
    );
  }

// Fetc
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $contactTable order by $colId ASC');
    return result;
  }

  Future<int> insertContact(EmergencyContact contact) async {
    Database db = await this.database;
    var result = await db.insert(contactTable, contact.toMap());
// print(await db.query(contactTable));
    return result;
  }

  Future<int> updateContact(EmergencyContact contact) async {
    final db = await this.database;
    var result = await db.update(
      contactTable, // The table you're updating
      contact.toMap(), // The updated values
      where: '$colId = ?', // The condition to find the right row to update
      whereArgs: [contact.id], // The value for the condition
    );
    return result;
  }

  Future<int> deleteContact(int id) async {
    final db = await this.database;
    var result = await db.delete(
      contactTable, // The table you're deleting from
      where: '$colId = ?', // The condition to find the right row to delete
      whereArgs: [id], // The value for the condition
    );
    return result;
  }

  Future<int> getCount() async {
    final db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $contactTable');
    int? count = Sqflite.firstIntValue(x);
    return count ?? 0; // Return 0 if null (though it should not be null)
  }

  Future<List<EmergencyContact>> getContactList() async {
    var contactMapList =
        await getContactMapList(); // Get 'Map List' from database
    int count =
        contactMapList.length; // Count the number of map entries in db table

    List<EmergencyContact> contactList = <EmergencyContact>[];
// For loop to create a 'Contact List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(EmergencyContact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }
}
