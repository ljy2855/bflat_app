import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recording_provider.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recorder App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon:
                  Icon(recordingProvider.isRecording ? Icons.stop : Icons.mic),
              onPressed: () => recordingProvider.toggleRecording(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await recordingProvider
                    .uploadRecording('https://yourserver.com/upload');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          success ? 'Upload successful' : 'Upload failed')),
                );
              },
              child: const Text('Upload Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
