import 'package:http/http.dart' as http;

class API {
  final client = http.Client();

  void dispose() {
    client.close();
  }
}
