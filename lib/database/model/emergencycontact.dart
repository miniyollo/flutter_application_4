class EmergencyContact {
  int?
      _id; // Nullable and final is okay for uninitialized as it defaults to null
  String? _name;
  String? _number;

  // Constructor for new contacts without an ID. Since _id is final and nullable,
  // it's implicitly initialized to null here, which is acceptable.
  EmergencyContact(this._number, this._name);

  // Named constructor for contacts with an existing ID. This constructor explicitly
  // initializes all final fields.
  EmergencyContact.withId(this._id, this._number, this._name);

  // Getters
  int get id => _id!;
  String get name => _name!;
  String get number => _number!;

  // Setters
  set number(String newNumber) {
    _number = newNumber;
  }

  set name(String newName) {
    _name = newName;
  }

  @override
  String toString() {
    return 'Contact: {id: $_id, name: $_name, number: $_number}';
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id; // Only include 'id' in the map if it's not null
    }
    map['number'] = _number;
    map['name'] = _name;
    return map;
  }

  //Extract a Contact Object from a Map object
  EmergencyContact.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._number = map['number'];
    this._name = map['name'];
  }
}
