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

  Future<void> animateToLocation(double lat, double lon) =>
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat, lon),
          15.0,
        ),
      );

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
    setState(() {
      mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });

    final List<MapMarker> markers = [];

    for (Toilet toilet in toilets) {
      final BitmapDescriptor icon = await determineMarkerIcon(
          toilet.category, toilet.openState.state, context);

      markers.add(
        MapMarker(
          id: toilets.indexOf(toilet).toString(),
          position: LatLng(toilet.latitude, toilet.longitude),
          icon: icon,
          toilet: toilet,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(markers);

    await updateMarkers();
  }

  Future<void> updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      context,
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
    final toilets = context.select((ToiletModel m) => m.toilets);
    final location = context.select((ToiletModel m) => m.location);
    final selectedToilet = context.select((ToiletModel m) => m.selectedToilet);
    final hasLocationPermission =
        context.select((ToiletModel m) => m.hasLocationPermission);

    if (selectedToilet != latestSelected) {
      latestSelected = selectedToilet;

      if (selectedToilet != null) {
        if (hasLocationPermission) {
          drawRoutes(
            location.latitude,
            location.longitude,
            selectedToilet.latitude,
            selectedToilet.longitude,
          );
        }

        animateToLocation(
          selectedToilet.latitude,
          selectedToilet.longitude,
        );
      } else {
        _polylines.clear();
      }
    }

    return GoogleMap(
      onMapCreated: (controller) => _onMapCreated(
        controller,
        context,
        toilets,
      ),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          location.latitude,
          location.longitude,
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
      onCameraMove: (position) => updateMarkers(position.zoom),
    );
  }
}
