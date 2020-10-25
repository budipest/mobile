import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '../models/Toilet.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  List<Toilet> data;

  Future<List<Toilet>> getToilets(LocationData location) async {
    final result = await API.getToilets();
    final data = result.map((toilet) => Toilet.fromMap(toilet)).toList();

    // Initialise distance property on every toilet
    data.forEach((toilet) {
      toilet.calculateDistance(location.latitude, location.longitude);
    });

    // Sort toilets based on their distance from the user
    data.sort((a, b) => a.distance.compareTo(b.distance));

    return data;
  }

  Future addToilet(Toilet data) async {
    var result = await API.addToilet(data.toJson());

    return result;
  }
}
