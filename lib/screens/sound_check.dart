import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:avatar_glow/avatar_glow.dart';

import '../services/recorder_service.dart';
import '../services/http_client_service.dart';

import 'record_analysis.dart';

class SoundCheckScreen extends StatefulWidget {
  @override
  _SoundCheckScreenState createState() => _SoundCheckScreenState();
}

class _SoundCheckScreenState extends State<SoundCheckScreen> {
  bool isRecording = false;
  bool isProcessing = false;
  int option = 0;
  double _progress = 0.0;
  String resultText = "Loading...";
  final RecorderService _recorderService = RecorderService();
  final HttpClientService _httpClientService = HttpClientService();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: buildScreen(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('SoundCheck'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget buildScreen() {
    if (!isRecording && !isProcessing) {
      return buildStartScreen();
    } else if (isRecording) {
      return buildRecordingScreen();
    } else if (isProcessing) {
      return buildLoadingScreen();
    }

    if (isRecording) {
      return buildRecordingScreen();
    } else if (isProcessing) {
      return buildLoadingScreen();
    } else {
      return buildStartScreen();
    }
  }

  Widget buildStartScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          child: CircleAvatar(
            child: Material(
              // Replace this child with your own
              elevation: 8.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.mic),
                radius: 40.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        buildOptionButton('Start Recording', startRecording),
        SizedBox(height: 20),
        buildOptionButton('Check Option', showOptions),
      ],
    );
  }

  Widget buildRecordingScreen() {
    if (option == 1) {
      _timer = Timer(Duration(seconds: 10), stopRecordingAndCheck);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          child: AvatarGlow(
            glowColor: Colors.blue,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            child: Material(
              // Replace this child with your own
              elevation: 8.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.mic),
                radius: 40.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          child: Text('Recording...'),
          height: 30,
        ),
        SizedBox(height: 20),
        buildOptionButton('Stop Recording', stopRecordingAndCheck),
      ],
    );
  }

  Widget buildOptionButton(String text, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
      ),
    );
  }

  void startRecording() {
    setState(() => isRecording = true);
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          timer.cancel();
        } else if (_progress >= 0.9) {
          _progress = 0.9;
          timer.cancel();
        }
      });
    });
    _recorderService.startRecording();
  }

  void stopRecordingAndCheck() async {
    setState(() {
      isRecording = false;
      isProcessing = true;
    });
    await _recorderService.stopRecording();
    checkSoundAndNavigate();
  }

  Future<void> checkSoundAndNavigate() async {
    final localPath = await _recorderService.localPath;
    if (localPath != null) {
      var response = await _httpClientService.checkSound(localPath);
      setState(() {
        _progress = 1.0; // 완료되면 100%로 설정
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SoundCheckResultScreen(response: response)),
      );
      setState(() {
        isRecording = false;
        isProcessing = false;
      });
    }
  }

  Future<String?> showOptions() {
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
                title: Text('Record until stop'),
                onTap: () => setOption(context, 0),
              ),
              ListTile(
                title: Text('Record for 10 seconds'),
                onTap: () => setOption(context, 1),
              ),
            ],
          ),
        );
      },
    );
  }

  void setOption(BuildContext context, int selectedOption) {
    Navigator.pop(context);
    setState(() => option = selectedOption);
  }

  Widget buildLoadingScreen() {
    return Center(
      // Center 위젯을 사용하여 자식 위젯을 화면 중앙에 배치
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Column의 메인축 정렬을 center로 설정
        children: [
          Text(
            resultText,
            style: TextStyle(
              fontSize: 36, // 글자 크기를 24로 설정
              fontWeight: FontWeight.bold, // 글자 두께를 bold로 설정/ 글자 색상을 파란색으로 설정
            ),
            textAlign: TextAlign.center, // 텍스트 정렬을 중앙 정렬로 설정
          ),
          Padding(
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          )
        ],
      ),
    );
  }
}

class SoundCheckResultScreen extends StatelessWidget {
  final http.Response response;

  SoundCheckResultScreen({required this.response});

  @override
  Widget build(BuildContext context) {
    final data = json.decode(response.body)["volumes"];
    List<Map<String, dynamic>> results =
        data.entries.map<Map<String, dynamic>>((entry) {
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
            child: ListView(
              children:
                  results.map((result) => buildResultTile(result)).toList(),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Retry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => RecordAnalysisScreen()),
                    // );
                  },
                  child: Text('Record Analysis'),
                ),
              ],
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget buildResultTile(Map<String, dynamic> result) {
    return ListTile(
      leading: Image.asset(
          "assets/images/${result['label']}_icon.png"), // 실제 앱에서는 각 항목에 맞는 아이콘으로 교체하세요.
      title: Text(result['label']),
      subtitle: LinearProgressIndicator(
        value: result['score'] / 100.0, // 100을 최대값으로 가정합니다.
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
      trailing: Text('${result['score'].toStringAsFixed(1)} / 100'),
    );
  }
}
