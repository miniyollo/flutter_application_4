import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.photos, // or Permission.storage for Android if saving images
    ].request();

    bool isCameraAccessPermitted =
        status[Permission.camera]?.isGranted ?? false;
    bool isStorageImagePermitted = status[Permission.photos]?.isGranted ??
        false; // Change to Permission.storage for Android if appropriate

    print("Camera Access: $isCameraAccessPermitted");
    print("Storage Access: $isStorageImagePermitted");
  }

  Future<void> _deleteImage(File imageFile) async {
    try {
      await imageFile.delete(); // Deletes the file from the file system
      setState(() {
        _imageFiles.remove(
            imageFile); // Updates the state to remove the image from the gallery
      });
    } catch (e) {
      // Handle errors, possibly with an error dialog
      print("Failed to delete the file: $e");
    }
  }

  void _openFullSizeImage(BuildContext context, File imageFile) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Full Size Image'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteImage(imageFile);
                Navigator.of(context).pop(); // Close the full-size view
              },
            )
          ],
        ),
        body: Center(
          child: InteractiveViewer(
            // Allows pinch-to-zoom and panning
            child: Image.file(imageFile),
          ),
        ),
      ),
    ));
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      File savedImage = await _saveImageLocally(photo);
      setState(() {
        _imageFiles.add(savedImage);
      });
    }
  }

  Future<File> _saveImageLocally(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/${DateTime.now().toIso8601String()}.png');
    await image.saveTo(file.path);
    return file;
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final dir = Directory(path);
    List<FileSystemEntity> entries = await dir.list().toList();
    setState(() {
      _imageFiles = entries.whereType<File>().toList();
    });
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: _imageFiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openFullSizeImage(context, _imageFiles[index]),
          child: Image.file(_imageFiles[index], fit: BoxFit.cover),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Access")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _imageFiles.isEmpty
                  ? Text("No images captured")
                  : _buildGridView(),
            ),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text("Open Camera"),
            ),
            ElevatedButton(
              onPressed: () => requestPermissions(),
              child: Text("Request Permissions"),
            ),
          ],
        ),
      ),
    );
  }
}
