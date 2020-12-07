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
    List<Toilet> data;

    try {
      final response = await client.get('$url/toilets');
      final body = json.decode(response.body)["data"];

      data = body
          .map<Toilet>((toiletRaw) => Toilet.fromMap(Map.from(toiletRaw)))
          .toList();
    } catch (error) {
      print(error);
    }

    return data;
  }

  static Future<Toilet> getToilet(String id) async {
    Toilet data;

    try {
      final response = await client.get('$url/toilets/$id');
      final body = json.decode(response.body);

      data = Toilet.fromMap(body);
    } catch (error) {
      print(error);
    }

    return data;
  }

  static Future<Toilet> addToilet(Toilet toilet) async {
    dynamic body;

    try {
      final response = await client.post(
        '$url/toilets',
        headers: _defaultHeaders,
        body: utf8.encode(json.encode(toilet.toJson())),
      );

      body = json.decode(response.body);
    } catch (error) {
      print(error);
    }

    return Toilet.fromMap(body);
  }

  static Future<Toilet> voteToilet(
    String toiletId,
    String userId,
    int vote,
  ) async {
    Toilet data;

    try {
      final response = await client.post(
        '$url/toilets/$toiletId/votes/$userId',
        headers: _defaultHeaders,
        body: utf8.encode(json.encode({"vote": vote})),
      );

      final body = json.decode(response.body)["toilet"];

      data = Toilet.fromMap(body);
    } catch (error) {
      print(error);
    }

    return data;
  }

  static Future<Toilet> addNote(
    String toiletId,
    String userId,
    String note,
  ) async {
    Toilet data;

    try {
      final response = await client.post(
        '$url/toilets/$toiletId/notes/$userId',
        headers: _defaultHeaders,
        body: utf8.encode(json.encode({"note": note})),
      );

      final body = json.decode(response.body)["toilet"];

      data = Toilet.fromMap(body);
    } catch (error) {
      print(error);
    }

    return data;
  }

  static Future<Toilet> removeNote(String toiletId, String userId) async {
    Toilet data;

    try {
      final response = await client.delete(
        '$url/toilets/$toiletId/notes/$userId',
        headers: _defaultHeaders,
      );

      final body = json.decode(response.body)["toilet"];

      data = Toilet.fromMap(body);
    } catch (error) {
      print(error);
    }

    return data;
  }
}
