import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';
import '../../core/services/GoogleMapsServices.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({this.key});

  final GlobalKey key;

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapWidget> {
  MapState();

  GoogleMapController mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Set<Polyline> _polylines = Set<Polyline>();
  bool _nightMode = false;
  BitmapDescriptor generalOpen;
  Toilet latestSelected;

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
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
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
      _polylines.add(directions);
    });
  }

  void _onMapCreated(GoogleMapController controller, BuildContext context) {
    setState(() {
      mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final toilets = Provider.of<ToiletModel>(context, listen: false).toilets;
    final userLocation =
        Provider.of<ToiletModel>(context, listen: false).location;
    final selectedToilet =
        context.select((ToiletModel model) => model.selectedToilet);
    final selectToilet =
        context.select((ToiletModel model) => model.selectToilet);

    if (selectedToilet != latestSelected) {
      latestSelected = selectedToilet;

      if (selectedToilet != null) {
        drawRoutes(
          userLocation.latitude,
          userLocation.longitude,
          selectedToilet.latitude,
          selectedToilet.longitude,
        );

        animateToLocation(
          selectedToilet.latitude,
          selectedToilet.longitude,
        );
      } else {
        _polylines.clear();
      }
    }

    toilets.forEach((toilet) async {
      double lat = toilet.latitude;
      double lng = toilet.longitude;
      MarkerId id = MarkerId(lat.toString() + lng.toString());
      Marker _marker = Marker(
        markerId: id,
        position: LatLng(lat, lng),
        icon: await determineMarkerIcon(
          toilet.category,
          toilet.openHours,
          context,
        ),
        onTap: () => selectToilet(toilet),
      );

      _markers[id] = _marker;
    });

    return GoogleMap(
      onMapCreated: (controller) => _onMapCreated(controller, context),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          userLocation.latitude,
          userLocation.longitude,
        ),
        zoom: 15.0,
      ),
      compassEnabled: true,
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_markers.values),
      polylines: _polylines,
      onTap: (LatLng coords) => selectToilet(null),
    );
  }
}
