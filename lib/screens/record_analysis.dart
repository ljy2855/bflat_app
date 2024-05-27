import 'package:flutter/material.dart';

class RecordAnalysisScreen extends StatefulWidget {
  @override
  _RecordAnalysisScreenState createState() => _RecordAnalysisScreenState();
}

class _RecordAnalysisScreenState extends State<RecordAnalysisScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Record Analysis'),
        centerTitle: true,
      ),
    );
  }
}
