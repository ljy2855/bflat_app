import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class HttpClientService {
  final String baseUrl = FlutterConfig.get('API_URL');

  Future<bool> uploadFile(String filePath) async {
    var uri = Uri.parse('$baseUrl/balance');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<http.Response> checkSound(String filePath) async {
    var uri = Uri.parse('$baseUrl/balance');
    var request = http.MultipartRequest('POST', uri);

    // 파일을 멀티파트 요청에 추가
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // 요청을 보내고 스트림된 응답을 받음
    http.StreamedResponse streamedResponse = await request.send();

    // StreamedResponse를 Response로 변환
    if (streamedResponse.statusCode == 200) {
      // 성공적인 응답을 받은 경우, 응답 본문을 읽어서 http.Response 객체로 변환
      String responseBody = await streamedResponse.stream.bytesToString();
      return http.Response(responseBody, streamedResponse.statusCode);
    } else {
      // 에러가 발생한 경우, 에러 상태 코드와 함께 빈 본문을 가진 Response 객체 반환
      return http.Response('', streamedResponse.statusCode);
    }
  }

  Future<http.Response> fetchData(String apiPath,
      {Map<String, String>? headers}) async {
    var uri = Uri.parse('$baseUrl$apiPath');
    var response = await http.get(uri, headers: headers);
    return response;
  }
}
