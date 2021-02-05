import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluster/fluster.dart';

import 'dart:async';

import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';
import '../../core/services/GoogleMapsServices.dart';
import "../../core/services/MapHelper.dart";

class MapWidget extends StatefulWidget {
  const MapWidget({this.key});

  final GlobalKey key;

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapWidget> {
  MapState();

  GoogleMapController mapController;
  final Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set<Polyline>();
  bool _nightMode = false;
  BitmapDescriptor generalOpen;
  Toilet latestSelected;

  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 15;

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      _nightMode = !_nightMode;
      mapController.setMapStyle(mapStyle);
    });
  }

  // Widget _nightModeToggler() {
  //   return FlatButton(
  //     child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
  //     onPressed: () {
  //       if (_nightMode) {
  //         _getFileData('assets/light_mode.json').then(_setMapStyle);
  //       } else {
  //         _getFileData('assets/dark_mode.json').then(_setMapStyle);
  //       }
  //     },
  //     textColor: Colors.white,
  //   );
  // }

  animateToLocation(double lat, double lon) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, lon),
        15.0,
      ),
    );
  }

  drawRoutes(
    double userLat,
    double userLon,
    double toiletLat,
    double toiletLon,
  ) async {
    final Polyline directions = await GoogleMapsServices.getRoutes(
      userLat,
      userLon,
      toiletLat,
      toiletLon,
    );

    setState(() {
      _polylines.clear();
      _polylines.add(directions);
    });
  }

  void _onMapCreated(GoogleMapController controller, BuildContext context,
      List<Toilet> toilets) async {
    final List<MapMarker> markers = [];

    for (Toilet toilet in toilets) {
      final BitmapDescriptor icon = await determineMarkerIcon(
          toilet.category, toilet.openState.state, context);

      markers.add(
        MapMarker(
          id: toilets.indexOf(toilet).toString(),
          position: LatLng(toilet.latitude, toilet.longitude),
          icon: icon,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(markers);

    setState(() {
      mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });

    await _updateMarkers();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      Colors.black,
      Colors.white,
      80,
    );

    setState(() {
      _markers
        ..clear()
        ..addAll(updatedMarkers);
    });
  }

  void selectToilet(BuildContext context, Toilet toilet) {
    Provider.of<ToiletModel>(context, listen: false).selectToilet(toilet);
  }

  @override
  Widget build(BuildContext context) {
    final _toilets = context.select((ToiletModel m) => m.toilets);
    final _location = context.select((ToiletModel m) => m.location);
    final _selectedToilet = context.select((ToiletModel m) => m.selectedToilet);
    final _hasLocationPermission =
        context.select((ToiletModel m) => m.hasLocationPermission);

    if (_selectedToilet != latestSelected) {
      latestSelected = _selectedToilet;

      if (_selectedToilet != null) {
        if (_hasLocationPermission) {
          drawRoutes(
            _location.latitude,
            _location.longitude,
            _selectedToilet.latitude,
            _selectedToilet.longitude,
          );
        }

        animateToLocation(
          _selectedToilet.latitude,
          _selectedToilet.longitude,
        );
      } else {
        _polylines.clear();
      }
    }

    return GoogleMap(
      onMapCreated: (controller) => _onMapCreated(
        controller,
        context,
        _toilets,
      ),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _location.latitude,
          _location.longitude,
        ),
        zoom: 15.0,
      ),
      mapType: MapType.normal,
      compassEnabled: false,
      rotateGesturesEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      indoorViewEnabled: true,
      buildingsEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: _markers.toSet(),
      polylines: _polylines,
      onTap: (LatLng coords) => selectToilet(context, null),
      onCameraMove: (position) => _updateMarkers(position.zoom),
    );
  }
}
