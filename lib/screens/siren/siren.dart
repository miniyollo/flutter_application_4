import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SirenPage extends StatefulWidget {
  @override
  _SirenPageState createState() => _SirenPageState();
}

class _SirenPageState extends State<SirenPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stopSiren() async {
    print("Stopping siren...");
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      print("Siren stopped: _isPlaying set to $_isPlaying");
    });
  }

  Future<void> _playSiren() async {
    print("Attempting to play siren...");
    if (!_isPlaying) {
      const url =
          'https://firebasestorage.googleapis.com/v0/b/sheroproject.appspot.com/o/siren%20(1).mp3?alt=media&token=0138f713-3d69-4fc9-8175-3ba3f347067e';
      await _audioPlayer.play(UrlSource(url));
      // var result = await _audioPlayer.play(AssetSource('siren.mp3'));
      print("Play result:"); // Output the result of the play attempt

      setState(() {
        _isPlaying = true; // Set to true when playback starts
        print("Playback started: _isPlaying set to $_isPlaying");
      });

      // Properly set up the listener for when playback finishes
      _audioPlayer.onPlayerComplete.listen((event) {
        print("Playback complete.");
        setState(() {
          _isPlaying = false; // Set back to false when playback finishes
          print("Playback finished: _isPlaying set to $_isPlaying");
        });
      });
    } else {
      print("Playback already in progress.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siren Player"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: _playSiren,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isPlaying ? 'Siren Playing...' : 'Double Tap to Play Siren',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopSiren,
              child: Text('Stop Siren', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
