import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/find_locale.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../services/recorder_service.dart';
import '../services/http_client_service.dart';

class SoundCheckScreen extends StatefulWidget {
  @override
  _SoundCheckScreenState createState() => _SoundCheckScreenState();
}

class _SoundCheckScreenState extends State<SoundCheckScreen> {
  bool isRecording = false;
  bool isProcessing = false;
  int option = 0;
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
          onPressed: () async {
            String? response = await _showModalBottomSheet(context); // 하단 시트 표시
            setState(() {
              if (response == 'record until stop') {
                option = 0;
              } else if (response == 'record for 10 seconds') {
                option = 1;
              }
            });
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
    Timer? _timer;

    void dispose() {
      _timer?.cancel(); // 타이머 자원 해제
      super.dispose();
    }

    void stopRecordingAndCheck() async {
      if (mounted) {
        setState(() {
          isRecording = false;
          isProcessing = true;
        });
        await _recorderService.stopRecording();
        await checkSoundAndNavigate();
      }

      dispose();
    }

    if (option == 1) {
      _timer = Timer(Duration(seconds: 10), stopRecordingAndCheck);
      print('set Timer');
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Recording...'), // 녹음 중임을 나타내는 텍스트
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: stopRecordingAndCheck,
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

  Widget soundCheckResultScreen(BuildContext context, http.Response response) {
    final Map<String, dynamic> _data = json.decode(response.body)["volumes"];

    List<Map<String, dynamic>> results =
        _data.entries.map<Map<String, dynamic>>((entry) {
      double score = (entry.value is double)
          ? entry.value
          : double.tryParse(entry.value.toString()) ?? 0.0;
      return {'label': entry.key, 'score': score};
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Check Results'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return ListTile(
                      leading: Icon(
                          Icons.music_note), // 실제 앱에서는 각 항목에 맞는 아이콘으로 교체하세요.
                      title: Text(result['label']),
                      subtitle: LinearProgressIndicator(
                        value: result['score'] / 100.0, // 100을 최대값으로 가정합니다.
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      trailing:
                          Text('${result['score'].toStringAsFixed(1)} / 100'),
                    );
                  })),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // retry 기능 구현, 예를 들어 다시 검사를 시작하는 로직
                    print("Retry button pressed");
                    Navigator.pop(context);
                  },
                  child: Text('retry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // analysis 기능 구현, 예를 들어 분석 페이지로 이동하거나 결과 분석 로직
                    print("Analysis button pressed");
                  },
                  child: Text('analysis'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkSoundAndNavigate() async {
    final String? localPath = await _recorderService.localPath;
    if (localPath != null) {
      var response = await _httpClientService.checkSound(localPath);
      if (response.statusCode == 200) {
        setState(() {
          isProcessing = false;
          resultText = "Processing successful!";
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    soundCheckResultScreen(context, response)));
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

  Future<String?> _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<String>(
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
                  Navigator.pop(context, 'record until stop'); // 선택 시 하단 시트 닫기
                  // 'record until stop' 동작 구현
                },
              ),
              ListTile(
                title: Text('record for 10 seconds'),
                onTap: () {
                  Navigator.pop(
                      context, 'record for 10 seconds'); // 선택 시 하단 시트 닫기
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
