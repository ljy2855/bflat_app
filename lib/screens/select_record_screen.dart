import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int? selectedRadio;
  List<String> files = []; // 파일 리스트 초기화

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
    final List<String> fileNames = entities
        .whereType<File>()
        .map((file) => file.path.split('/').last)
        .toList();

    setState(() {
      files = fileNames;
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      final newPath = directory.path + '/' + file.path.split('/').last;
      await file.copy(newPath);

      // 파일 리스트 업데이트
      loadFiles();
    }
  }

  void deleteFile(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + '/' + files[index];
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      loadFiles(); // 파일 리스트 업데이트
    }
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
                  ? () {
                      // 선택된 파일 업로드
                      print('Uploading ${files[selectedRadio!]}');
                    }
                  : null,
              child: Text('Analysis'),
            ),
          ),
        ],
      ),
    );
  }
}
