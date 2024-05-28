import 'package:flutter/material.dart';

class AnalysisResultWidget extends StatefulWidget {
  final Map<String, dynamic> data; // Data from the server

  const AnalysisResultWidget({super.key, required this.data});

  @override
  State<AnalysisResultWidget> createState() => _AnalysisResultWidgetState();
}

class _AnalysisResultWidgetState extends State<AnalysisResultWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text('${entry.key.toUpperCase()}: Tap to listen'),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
