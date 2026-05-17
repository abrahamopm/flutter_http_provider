import 'package:http/http.dart' as http;

class HttpProvider {
  HttpProvider({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  http.Client get client => _client;

  void close() => _client.close();
}