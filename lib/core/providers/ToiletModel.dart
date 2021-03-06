import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../common/openHourUtils.dart';
import '../models/Toilet.dart';
import '../services/API.dart';

class ToiletModel extends ChangeNotifier {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  // user-related data
  Position _userLocation = Position.fromMap({
    "latitude": 47.497643763874876,
    "longitude": 19.054028096671686,
  });
  LocationPermission _locationPermissionStatus;
  String _userId;

  // toilets
  List<Toilet> _toilets = List<Toilet>.empty(growable: true);
  Toilet _selected;

  // errors
  String _appError;
  BuildContext _globalContext;

  // user-related getters
  Position get location => _userLocation;
  bool get hasLocationPermission =>
      (_locationPermissionStatus == LocationPermission.always ||
          _locationPermissionStatus == LocationPermission.whileInUse);
  String get userId => _userId;

  // toilet getters
  List<Toilet> get toilets => _toilets;
  Toilet get suggestedToilet => _toilets.firstWhere(
        (element) => element.openState.state == OpenState.OPEN,
        orElse: () => _toilets[0],
      );
  Toilet get selectedToilet => _selected;
  bool get loaded => _toilets.length > 0;
  bool get hasSelected => _selected != null;

  // error getters
  String get appError => _appError;
  set globalContext(BuildContext context) {
    _globalContext = context;
  }

  Timer _timer;

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

      List<Toilet> toiletsRaw = responses[1];

      orderToilets(toiletsRaw);

      _timer = Timer.periodic(Duration(seconds: 15), (Timer t) async {
        _userLocation = await Geolocator.getCurrentPosition();
        orderToilets(toiletsRaw);
      });
    } catch (error) {
      print(error);
      _appError = "errorData";
      notifyListeners();
      return;
    }
  }

  Toilet processToilet(Toilet raw) {
    raw.distance = Geolocator.distanceBetween(
      raw.latitude,
      raw.longitude,
      _userLocation.latitude,
      _userLocation.longitude,
    ).round();

    raw.distanceString = raw.distance > 1000
        ? "${(raw.distance / 1000).toStringAsFixed(1)} km"
        : "${raw.distance} m";

    raw.openState.updateState();

    return raw;
  }

  void orderToilets(List<Toilet> toiletsRaw) async {
    if (hasLocationPermission) {
      final location = await Geolocator.getCurrentPosition();
      _userLocation = location;
    }

    toiletsRaw.forEach((Toilet toilet) => processToilet(toilet));
    toiletsRaw.sort((a, b) => a.distance.compareTo(b.distance));

    _toilets = toiletsRaw;

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
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnackBar("errorLocation");
      return;
    }

    _locationPermissionStatus = await Geolocator.checkPermission();
    if (_locationPermissionStatus == LocationPermission.deniedForever) {
      showErrorSnackBar("errorLocation");
      return;
    }

    if (_locationPermissionStatus == LocationPermission.denied) {
      _locationPermissionStatus = await Geolocator.requestPermission();
      if (_locationPermissionStatus != LocationPermission.whileInUse &&
          _locationPermissionStatus != LocationPermission.always) {
        showErrorSnackBar("errorLocation");
        return;
      }
    }

    _userLocation = await Geolocator.getCurrentPosition();

    notifyListeners();
  }

  Future<void> addToilet(Toilet item) async {
    Toilet addedToilet;

    try {
      addedToilet = await API.addToilet(item);

      await analytics.logEvent(name: 'add_toilet', parameters: {
        'toilet_id': item.id,
        'toilet_name': item.name,
      });

      addedToilet = processToilet(addedToilet);
      _toilets.add(addedToilet);
      selectToilet(addedToilet);

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("errorOnServer");
    }
  }

  Future<void> selectToilet(Toilet item) async {
    _selected = item;
    notifyListeners();

    if (item != null) {
      await analytics.logEvent(name: 'select_toilet', parameters: {
        'toilet_id': item.id,
        'toilet_name': item.name,
      });
    }
  }

  Future<void> voteToilet(int vote) async {
    Toilet updatedToilet;

    try {
      updatedToilet = await API.voteToilet(_selected.id, _userId, vote);

      final int index = _toilets.indexOf(_selected);

      updatedToilet = processToilet(updatedToilet);
      _toilets[index] = updatedToilet;
      _selected = updatedToilet;

      await analytics.logEvent(name: 'add_vote', parameters: {
        'toilet_id': updatedToilet.id,
        'toilet_name': updatedToilet.name,
        'vote': vote,
      });

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("errorOnServer");
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

      await analytics.logEvent(name: 'add_note', parameters: {
        'toilet_id': updatedToilet.id,
        'toilet_name': updatedToilet.name,
      });

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("errorOnServer");
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

      await analytics.logEvent(name: 'remove_note', parameters: {
        'toilet_id': updatedToilet.id,
        'toilet_name': updatedToilet.name,
      });

      notifyListeners();
    } catch (error) {
      print(error);
      showErrorSnackBar("errorOnServer");
    }
  }

  String decodeErrorCode(String code) {
    switch (code) {
      case "errorData":
        return AppLocalizations.of(_globalContext).errorData;
      case "errorOnServer":
        return AppLocalizations.of(_globalContext).errorOnServer;
      case "errorMissingFields":
        return AppLocalizations.of(_globalContext).errorMissingFields;
      case "errorRequiredFields":
        return AppLocalizations.of(_globalContext).errorRequiredFields;
      case "errorLocation":
        return AppLocalizations.of(_globalContext).errorLocation;
      default:
        return AppLocalizations.of(_globalContext).errorTitle;
    }
  }

  void showErrorSnackBar(String errorCode) {
    ScaffoldMessenger.of(_globalContext).showSnackBar(
      SnackBar(
        content: Text(decodeErrorCode(errorCode)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
