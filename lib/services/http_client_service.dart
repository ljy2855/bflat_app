import 'package:http/http.dart' as http;

class HttpClientService {
  final String baseUrl = "http:/test.com";

  Future<bool> uploadFile(String filePath) async {
    var uri = Uri.parse('$baseUrl/check_balance');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<http.Response> fetchData(String apiPath,
      {Map<String, String>? headers}) async {
    var uri = Uri.parse('$baseUrl$apiPath');
    var response = await http.get(uri, headers: headers);
    return response;
  }
}
