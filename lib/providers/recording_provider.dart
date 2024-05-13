import 'package:flutter/material.dart';
import '../services/recorder_service.dart';

class RecordingProvider with ChangeNotifier {
  final RecorderService _recorderService = RecorderService();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<void> toggleRecording() async {
    if (_isRecording) {
      await _recorderService.stopRecording();
    } else {
      await _recorderService.startRecording();
    }
    _isRecording = !_isRecording;
    notifyListeners();
  }
}
