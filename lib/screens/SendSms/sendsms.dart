import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';

import '../../database/contactdb.dart';
import '../../database/model/emergencycontact.dart';

class SendSms extends StatefulWidget {
  const SendSms({Key? key}) : super(key: key);

  @override
  State<SendSms> createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;

  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeShakeDetector();
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () async {
        // Call your method to send SMS here
        // ignore: unused_local_variable
        String recipients = "";
        List<EmergencyContact> contactList =
            await DatabaseHelper().getContactList();
        print(contactList.length);
        if (contactList.isEmpty) {
          // Fluttertoast.showToast(msg: "emergency contact is empty");
        } else {
          String messageBody =
              "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";

          if (await isPermissionGranted()) {
            print("Permission granted");
            for (var element in contactList) {
              var smsResult = await _sendSms(
                  element.number, "I am in trouble $messageBody");
              print("SMS send result: $smsResult");
            }
          } else {
            print("SMS permission not granted");
            // Fluttertoast.showToast(msg: "SMS permission not granted");
          }
        }
      },
    );
  }

  _getPermission() async => await [Permission.sms].request();

  Future<bool> isPermissionGranted() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      // Request permissions if not already granted
      var result = await Permission.sms.request();
      return result.isGranted;
    }
    return true; // Permissions were already granted
  }

  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);

    if (result == SmsStatus.sent) {
      print("Sent");
      // Fluttertoast.showToast(msg: "send");
    } else {
      // Fluttertoast.showToast(msg: "failed");
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _curentPosition = position;
        print(_curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // To minimize the column's size to its children size
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Get Loc'),
            ),
            const SizedBox(
                height: 20), // Provides space between the two buttons
            ElevatedButton(
              onPressed: () async {
                // ignore: unused_local_variable
                String recipients = "";
                List<EmergencyContact> contactList =
                    await DatabaseHelper().getContactList();
                print(contactList.length);
                if (contactList.isEmpty) {
                  // Fluttertoast.showToast(msg: "emergency contact is empty");
                } else {
                  String messageBody =
                      "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";

                  if (await isPermissionGranted()) {
                    print("Permission granted");
                    for (var element in contactList) {
                      var smsResult = await _sendSms(
                          element.number, "I am in trouble $messageBody");
                      print("SMS send result: $smsResult");
                    }
                  } else {
                    print("SMS permission not granted");
                    // Fluttertoast.showToast(msg: "SMS permission not granted");
                  }
                }
              },
              child: const Text('Send Alert'),
            ),
          ],
        ),
      ),
    );
  }
}
