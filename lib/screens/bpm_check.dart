import 'package:flutter/material.dart';

class BPMControlScreen extends StatefulWidget {
  @override
  _BPMControlScreenState createState() => _BPMControlScreenState();
}

class _BPMControlScreenState extends State<BPMControlScreen> {
  double _rotation = 0;
  int _bpm = 60;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotation += details.delta.dx * 0.01;
      _bpm = (60 + _rotation * 10).clamp(20, 200).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
          },
        ),
        title: Text('BPM Check'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Add your forward button functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorButton(Colors.blue),
                _buildColorButton(Colors.grey.shade300),
                _buildColorButton(Colors.grey.shade400),
                _buildColorButton(Colors.grey.shade500),
              ],
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '$_bpm BPM',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onPanUpdate: _onPanUpdate,
              child: Transform.rotate(
                angle: _rotation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Icon(Icons.circle,
                        size: 100, color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton('4/4'),
                _buildControlButton(Icons.play_arrow),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildControlButton(dynamic label) {
    return ElevatedButton(
      onPressed: () {
        // Add your button functionality here
      },
      child: label is String ? Text(label) : Icon(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.grey.shade300, // primary 대신 사용
        foregroundColor: Colors.black, // onPrimary 대신 사용
      ),
    );
  }
}
