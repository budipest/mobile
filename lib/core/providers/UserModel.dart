import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import "./ToiletModel.dart";

import '../models/Toilet.dart';
import '../models/Note.dart';
import '../services/API.dart';

class UserModel extends ChangeNotifier {
  UserModel(this._toiletModel);

  ToiletModel _toiletModel;
  final Location _location = new Location();
  LocationData _userLocation;
  final String _userId = "hey";

  LocationData get location => _userLocation;
  String get userId => _userId;

  Future<void> checkPermission() async {
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

  void init(BuildContext context) async {
    await checkPermission();

    _userLocation = await _location.getLocation();

    _location.onLocationChanged.listen((event) {
      updateData(context, event);
    });
  }

  void updateData(BuildContext context, LocationData location) async {
    _userLocation = location;
    _toiletModel.init(location);
    notifyListeners();
  }
}
