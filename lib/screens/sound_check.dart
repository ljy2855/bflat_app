import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/find_locale.dart';
import 'dart:async';
import '../services/recorder_service.dart';
import '../services/http_client_service.dart';

class SoundCheckScreen extends StatefulWidget {
  @override
  _SoundCheckScreenState createState() => _SoundCheckScreenState();
}

class _SoundCheckScreenState extends State<SoundCheckScreen> {
  bool isRecording = false;
  bool isProcessing = false;
  String resultText = "Finding...";
  final RecorderService _recorderService = RecorderService();
  final HttpClientService _httpClientService = HttpClientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SoundCheck'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 동작
          },
        ),
      ),
      body: Center(
        child: isRecording ? buildRecordingScreen() : buildStartScreen(),
      ),
    );
  }

  Widget buildStartScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              isRecording = true; // 'start' 버튼을 누르면 녹음 상태로 변경
            });
            _recorderService.startRecording();
          },
          child: Text('start'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showModalBottomSheet(context); // 하단 시트 표시
          },
          child: Text('check option'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildRecordingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Recording...'), // 녹음 중임을 나타내는 텍스트
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isRecording = false;
              isProcessing = true;
            });

            await _recorderService.stopRecording();
            await checkSoundAndNavigate();
          },
          child: Text('stop'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildFindingScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finding Results"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Finding...',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              )
            : Text(resultText,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> checkSoundAndNavigate() async {
    final String? localPath = await _recorderService.localPath;
    print("check");
    if (localPath != null) {
      print("notnull");
      var response = await _httpClientService.checkSound(localPath);
      if (response.statusCode == 200) {
        print("200");
        setState(() {
          isProcessing = false;
          resultText = "Processing successful!";
        });
      } else {
        setState(() {
          isProcessing = false;
          resultText = "Error processing the file.";
        });
      }
    } else {
      setState(() {
        isProcessing = false;
        resultText = "Failed to record.";
      });
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('record until stop'),
                onTap: () {
                  Navigator.pop(context); // 선택 시 하단 시트 닫기
                  // 'record until stop' 동작 구현
                },
              ),
              ListTile(
                title: Text('record for 10 seconds'),
                onTap: () {
                  Navigator.pop(context); // 선택 시 하단 시트 닫기
                  // 'record for 10 seconds' 동작 구현
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
