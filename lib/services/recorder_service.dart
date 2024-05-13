import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:intl/intl.dart';
import 'http_client_service.dart'; // HttpClientService를 import

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _localPath;
  final HttpClientService _httpClientService =
      HttpClientService(); // HttpClientService 인스턴스 생성

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      // 현재 날짜와 시간을 '년월일_시분초' 형식으로 포맷팅
      final formattedDateTime =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final localPath =
          '${directory.path}/recording_$formattedDateTime.mp4'; // 파일 확장자는 필요에 따라 변경 가능
      _localPath = localPath; // localPath 상태 업데이트
      await _recorder.start(const RecordConfig(), path: localPath); // 녹음 시작
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop(); // 녹음 중지
  }

  Future<String?> get localPath async {
    return _localPath; // 녹음 파일 경로 반환
  }
}
