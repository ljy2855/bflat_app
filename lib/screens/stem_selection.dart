import 'package:bflat_app/screens/sound_check.dart';
import 'package:flutter/material.dart';

class StemSelectionScreen extends StatefulWidget {
  @override
  _StemSelectionScreenState createState() => _StemSelectionScreenState();
}

class _StemSelectionScreenState extends State<StemSelectionScreen> {
  Set<String> _selectedInstruments = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Stem Selection'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select the Instrument',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInstrumentButton('Bass'),
                _buildInstrumentButton('Vocal'),
                _buildInstrumentButton('Guitar'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInstrumentButton('Drum'),
                _buildInstrumentButton('KeyBoard'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SoundCheckScreen()),
                );
              },
              child: Text('select'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInstrumentButton(String instrument) {
    String _imagePath = "assets/images/${instrument.toLowerCase()}_icon.png";

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (_selectedInstruments.contains(instrument)) {
            _selectedInstruments.remove(instrument);
          } else {
            _selectedInstruments.add(instrument);
          }
        });
      },
      child: Image.asset(_imagePath),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedInstruments.contains(instrument)
            ? Colors.grey[500]
            : Colors.grey[300],
        foregroundColor: _selectedInstruments.contains(instrument)
            ? Colors.white
            : Colors.black,
        minimumSize: Size(100, 100),
      ),
    );

    // return SizedBox(
    //     child: ToggleButtons(
    //         onPressed: (int index) => {
    //               if (_selectedInstruments.remove(instrument) == false)
    //                 {
    //                   setState(() {
    //                     _selectedInstruments.add(instrument);
    //                   })
    //                 }
    //             },
    //         children: [Image.asset(_imagePath)],
    //         borderRadius: BorderRadius.circular(15),
    //         disabledColor: Colors.grey[500],
    //         fillColor: Colors.black54,
    //         isSelected: [_selectedInstruments.contains(instrument)]));
  }
}
