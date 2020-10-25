import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:async';

import '../../core/models/Toilet.dart';
import '../../core/common/openHourUtils.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.toilets, this.userLocation, this.selectToilet,
      {this.onMapCreated, this.key});

  final List<Toilet> toilets;
  final LocationData userLocation;
  final Function(Toilet) selectToilet;
  final Function onMapCreated;
  final GlobalKey key;

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapWidget> {
  MapState();

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool _nightMode = false;
  BitmapDescriptor generalOpen;

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

  animateToUser() {
    animateToLocation(
      widget.userLocation.latitude,
      widget.userLocation.longitude,
    );
  }

  animateToLocation(double lat, double lon) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lon),
      zoom: 15.0,
    )));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
      animateToUser();
    });
    widget.onMapCreated();
  }

  @override
  Widget build(BuildContext context) {
    widget.toilets.forEach((toilet) async {
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
        onTap: () => widget.selectToilet(toilet),
      );
      setState(() {
        markers[id] = _marker;
      });
    });

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(47.498290, 19.033493),
        zoom: 15.0,
      ),
      compassEnabled: true,
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(markers.values),
      onTap: (LatLng coords) => widget.selectToilet(null),
    );
  }
}
