import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../common/openHourUtils.dart';
import '../models/Toilet.dart';
import '../models/Note.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  final List<Toilet> _toilets = new List<Toilet>();
  Toilet _selected;

  List<Toilet> get toilets => _toilets;
  Toilet get suggestedToilet =>
      _toilets.firstWhere((element) => isOpen(element.openHours));
  Toilet get selectedToilet => _selected;

  void init(LocationData userLocation) async {
    final toilets = await API.getToilets(userLocation);

    _toilets.clear();

    toilets.forEach((item) {
      _toilets.add(item);
    });

    notifyListeners();
  }

  void addToilet(Toilet item) {
    API.addToilet(item);
    _toilets.add(item);
    selectToilet(item);
  }

  void selectToilet(Toilet item) {
    _selected = item;
    notifyListeners();
  }
}
