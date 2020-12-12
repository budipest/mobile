import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Toilet.dart';

class API {
  static http.Client client;
  static final url = "https://budipest-api.herokuapp.com/api/v1";
  static final _defaultHeaders = {
    "Accept": "application/json",
    "Content-type": "application/json"
  };

  static void init() {
    client = http.Client();
  }

  static Future<List<Toilet>> getToilets() async {
    final response = await client.get('$url/toilets');
    final body = json.decode(response.body)["data"];

    return body
        .map<Toilet>((toiletRaw) => Toilet.fromMap(Map.from(toiletRaw)))
        .toList();
  }

  static Future<Toilet> getToilet(String id) async {
    final response = await client.get('$url/toilets/$id');
    final body = json.decode(response.body);

    return Toilet.fromMap(body);
  }

  static Future<Toilet> addToilet(Toilet toilet) async {
    print("api start");
    final response = await client.post(
      '$url/toilets',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode(toilet.toJson())),
    );
    print("api aft res");
    final body = json.decode(response.body)["toilet"];
    print("api aft json");
    return Toilet.fromMap(body);
  }

  static Future<Toilet> voteToilet(
    String toiletId,
    String userId,
    int vote,
  ) async {
    final response = await client.post(
      '$url/toilets/$toiletId/votes/$userId',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode({"vote": vote})),
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }

  static Future<Toilet> addNote(
    String toiletId,
    String userId,
    String note,
  ) async {
    final response = await client.post(
      '$url/toilets/$toiletId/notes/$userId',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode({"note": note})),
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }

  static Future<Toilet> removeNote(String toiletId, String userId) async {
    final response = await client.delete(
      '$url/toilets/$toiletId/notes/$userId',
      headers: _defaultHeaders,
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }
}
