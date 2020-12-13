import "package:flutter/material.dart" show Colors;
import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng, Polyline, PolylineId;
import 'package:http/http.dart' as http;

class GoogleMapsServices {
  static Future<String> getAPIKey() async {
    final String raw = await rootBundle.loadString("assets/secrets.json");
    return json.decode(raw)["GCP_API_KEY"];
  }

  static Future<Polyline> getRoutes(
    double userLat,
    double userLon,
    double toiletLat,
    double toiletLon,
  ) async {
    final String googleApiKey = await getAPIKey();
    String _url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${userLat},${userLon}&destination=${toiletLat},${toiletLon}&mode=walking&key=$googleApiKey";

    final response = await http.get(_url);
    Map values = json.decode(response.body);
    final encodedPoly = values["routes"][0]["overview_polyline"]["points"];

    return Polyline(
      polylineId: PolylineId(LatLng(userLat, userLon).toString()),
      width: 4,
      points: _convertToLatLng(_decodePoly(encodedPoly)),
      color: Colors.black,
    );
  }

  static List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  static List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }
}
