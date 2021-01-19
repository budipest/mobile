import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common/openHourUtils.dart';
import '../models/Toilet.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  // user-related data
  final Location _location = Location();
  LocationData _userLocation = LocationData.fromMap({
    "latitude": 47.497643763874876,
    "longitude": 19.054028096671686,
  });
  PermissionStatus _locationPermissionStatus;
  String _userId;

  // toilets
  List<Toilet> _toilets = List<Toilet>.empty(growable: true);
  Toilet _selected;

  // errors
  String _appError;
  BuildContext _globalContext;

  // user-related getters
  LocationData get location => _userLocation;
  bool get hasLocationPermission =>
      _locationPermissionStatus == PermissionStatus.granted;
  String get userId => _userId;

  // toilet getters
  List<Toilet> get toilets => _toilets;
  Toilet get suggestedToilet => _toilets.firstWhere(
        (element) => element.openState.state == OpenState.OPEN,
        orElse: () => _toilets[0],
      );
  Toilet get selectedToilet => _selected;
  bool get loaded => _toilets.length > 0;

  // error getters
  String get appError => _appError;
  set globalContext(BuildContext context) {
    _globalContext = context;
  }

  ToiletModel() {
    API.init();
    initLocation();
    initUserId();
  }

  void initLocation() async {
    try {
      final List responses = await Future.wait([
        checkLocationPermission(),
        API.getToilets(),
      ]);

      _toilets = responses[1];

      if (_locationPermissionStatus == PermissionStatus.granted) {
        _location.onLocationChanged.listen((LocationData location) {
          orderToilets(location);
        });
      } else {
        orderToilets(_userLocation);
      }
    } catch (error) {
      print(error);
      _appError = "error.data";
      notifyListeners();
      return;
    }
  }

  Toilet processToilet(Toilet raw) {
    raw.calculateDistance(_userLocation.latitude, _userLocation.longitude);
    raw.openState.updateState();
    return raw;
  }

  void orderToilets(LocationData location) async {
    _userLocation = location;

    _toilets.forEach((Toilet toilet) => processToilet(toilet));
    _toilets.sort((a, b) => a.distance.compareTo(b.distance));

    notifyListeners();
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

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _locationPermissionStatus = await _location.hasPermission();

    notifyListeners();
  }

  Future<void> askLocationPermission() async {
    _location.getLocation();
    _locationPermissionStatus = await _location.requestPermission();
    notifyListeners();
  }

  Future<void> addToilet(Toilet item) async {
    Toilet addedToilet;

    try {
      addedToilet = await API.addToilet(item);

      addedToilet = processToilet(addedToilet);
      _toilets.add(addedToilet);
      selectToilet(addedToilet);
    } catch (error) {
      print(error);
      showErrorSnackBar("error.onServer");
    }
  }

  void selectToilet(Toilet item) {
    _selected = item;
    notifyListeners();
  }

  Future<void> voteToilet(int vote) async {
    Toilet updatedToilet;

    try {
      updatedToilet = await API.voteToilet(_selected.id, _userId, vote);

      final int index = _toilets.indexOf(_selected);

      updatedToilet = processToilet(updatedToilet);
      _toilets[index] = updatedToilet;
      _selected = updatedToilet;

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("error.onServer");
    }
  }

  Future<void> addNote(String note) async {
    Toilet updatedToilet;

    try {
      updatedToilet = await API.addNote(_selected.id, _userId, note);

      final int index = _toilets.indexOf(_selected);

      updatedToilet = processToilet(updatedToilet);
      _toilets[index] = updatedToilet;
      _selected = updatedToilet;

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("error.onServer");
    }
  }

  Future<void> removeNote() async {
    Toilet updatedToilet;

    try {
      updatedToilet = await API.removeNote(_selected.id, _userId);

      final int index = _toilets.indexOf(_selected);

      updatedToilet = processToilet(updatedToilet);
      _toilets[index] = updatedToilet;
      _selected = updatedToilet;

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("error.onServer");
    }
  }

  void showErrorSnackBar(String errorCode) {
    ScaffoldMessenger.of(_globalContext).showSnackBar(
      SnackBar(
        content: Text(
          FlutterI18n.translate(_globalContext, errorCode),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
