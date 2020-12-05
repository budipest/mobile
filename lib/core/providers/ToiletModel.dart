import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common/openHourUtils.dart';
import '../models/Toilet.dart';
import '../models/Note.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  // user-related data
  final Location _location = new Location();
  LocationData _userLocation;
  String _userId;

  // toilets
  List<Toilet> _toilets = new List<Toilet>();
  Toilet _selected;

  // user-related getters
  LocationData get location => _userLocation;
  String get userId => _userId;

  // toilet getters
  List<Toilet> get toilets => _toilets;
  Toilet get suggestedToilet =>
      _toilets.firstWhere((element) => isOpen(element.openHours));
  Toilet get selectedToilet => _selected;
  bool get loaded => _toilets.length > 0;

  ToiletModel() {
    API.init();
    initLocation();
    initUserId();
  }

  void initLocation() async {
    await checkLocationPermission();

    _location.onLocationChanged.listen((LocationData event) async {
      _userLocation = event;

      final toilets = await API.getToilets(event);

      _toilets.clear();

      toilets.forEach((item) {
        _toilets.add(item);
      });

      notifyListeners();
    });
  }

  void initUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storedID = prefs.getString('userId');
    final uuid = Uuid();

    if (storedID != null) {
      _userId = storedID;
    } else {
      _userId = uuid.v4();
      await prefs.setString('userId', _userId);
    }
  }

  Future<void> checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        print("does not have service enabled");
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("denied permission");
      }
    }
  }

  Future<void> addToilet(Toilet item) async {
    final Toilet addedToilet = await API.addToilet(item);
    _toilets.add(addedToilet);
    selectToilet(addedToilet);
  }

  void selectToilet(Toilet item) {
    _selected = item;
    notifyListeners();
  }

  Future<void> voteToilet(int vote) async {
    final Toilet updatedToilet =
        await API.voteToilet(_selected.id, _userId, vote);
    final int index = _toilets.indexOf(_selected);

    updatedToilet.calculateDistance(
      _userLocation.latitude,
      _userLocation.longitude,
    );

    _toilets[index] = updatedToilet;
    _selected = updatedToilet;

    notifyListeners();
  }
}
