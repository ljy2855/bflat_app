import 'dart:convert';
import 'dart:io';
import 'package:bflat_app/screens/anlaysis_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/http_client_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int? selectedRadio;
  List<String> files = []; // 파일 리스트 초기화
  final HttpClientService httpClientService = HttpClientService();

  @override
  void initState() {
    super.initState();
    requestPermission(); // 권한 요청 함수 호출
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    loadFiles(); // 파일 로드 함수 호출
  }

  Future<void> loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    final List<FileSystemEntity> entities = await dir.list().toList();

    List<String> fileNames = entities
        .whereType<File>()
        .map((file) => file.path) // 파일의 전체 경로를 저장
        .toList();

    setState(() {
      files = fileNames;
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      String originalPath = result.files.single.path!;
      File file = File(originalPath);
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${file.path.split('/').last}';

      await file.copy(newPath); // 파일을 새 위치로 복사

      loadFiles(); // 파일 리스트를 업데이트
    } else {
      showErrorDialog('No file selected or path is invalid.');
    }
  }

  void deleteFile(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${files[index]}';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      loadFiles(); // 파일 리스트 업데이트
    } else {
      showErrorDialog('File does not exist.');
    }
  }

  Future<void> uploadAndAnalyzeFile(String filePath) async {
    print(filePath); // 전체 경로가 출력되어야 합니다.
    try {
      Response response = await httpClientService.analysis(filePath);

      if (response.statusCode == 200) {
        // 응답 데이터를 파싱하여 필요한 데이터 추출
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          // Navigator를 사용하여 AnalysisResultWidget로 화면 전환 및 데이터 전달
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AnalysisResultWidget(data: jsonResponse['files'])),
          );
        } else {
          showErrorDialog('Analysis failed: ${jsonResponse['error_message']}');
        }
      } else {
        showErrorDialog('Failed to analyze the file. Please try again.');
      }
    } catch (e) {
      showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Lists'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 기능 구현
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => pickFile(),
                  child: Text('Upload File'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 모든 항목 삭제 기능
                  },
                  child: Text('delete all'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        files.removeAt(index); // 파일 삭제
                      });
                    },
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        selectedRadio = value; // 선택된 라디오 버튼 업데이트
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedRadio != null
                  ? () => uploadAndAnalyzeFile(files[selectedRadio!])
                  : null,
              child: Text('Analysis'),
            ),
          ),
        ],
      ),
    );
  }
}
