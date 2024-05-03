import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpClientService {
  final String? baseUrl = dotenv.env['API_URL'];

  Future<bool> uploadFile(String filePath) async {
    var uri = Uri.parse('$baseUrl/balance');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<http.StreamedResponse> checkSound(String filePath) async {
    var uri = Uri.parse('$baseUrl/balance');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    return response;
  }

  Future<http.Response> fetchData(String apiPath,
      {Map<String, String>? headers}) async {
    var uri = Uri.parse('$baseUrl$apiPath');
    var response = await http.get(uri, headers: headers);
    return response;
  }
}
