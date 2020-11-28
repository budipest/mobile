import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../common/openHourUtils.dart';
import '../models/Toilet.dart';
import '../models/Note.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  final List<Toilet> _items = new List<Toilet>();

  List<Toilet> get items => _items;
  Toilet get suggestedToilet =>
      _items.firstWhere((element) => isOpen(element.openHours));

  void init(LocationData userLocation) async {
    final toilets = await API.getToilets(userLocation);

    _items.clear();

    toilets.forEach((item) {
      _items.add(item);
    });

    notifyListeners();
  }

  void add(Toilet item) {
    _items.add(item);
    notifyListeners();
  }
}
