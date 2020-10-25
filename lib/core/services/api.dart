import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static http.Client client;
  static final url = "https://budipest-api.herokuapp.com/api/v1";

  static void init() {
    client = http.Client();
  }

  static Future<List<Map>> getToilets() async {
    try {
      final response = await client.get('$url/toilets');
      final body = json.decode(response.body);

      return body;
    } finally {
      client.close();
    }
  }

  static Future<Map> getToilet(String id) async {
    try {
      final response = await client.get('$url/toilets/$id');
      final body = json.decode(response.body);

      return body;
    } finally {
      client.close();
    }
  }

  static Future<Map> addToilet(Map toilet) async {
    try {
      final response = await client.post('$url/toilets', body: toilet);
      final body = json.decode(response.body);

      return body;
    } finally {
      client.close();
    }
  }
}
