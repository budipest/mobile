import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:async';

import '../../core/models/toilet.dart';
import '../../core/common/determineIcon.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.toilets);

  final List<Toilet> toilets;

  @override
  State<StatefulWidget> createState() => MapState(toilets);
}

class MapState extends State<MapWidget> {
  MapState(this.toilets);

  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Toilet> toilets;
  Location location = new Location();
  bool _nightMode = false;
  BitmapDescriptor generalOpen;

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      _nightMode = !_nightMode;
      _mapController.setMapStyle(mapStyle);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _nightModeToggler() {
    return FlatButton(
        child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
        onPressed: () {
          if (_nightMode) {
            _getFileData('assets/light_mode.json').then(_setMapStyle);
          } else {
            _getFileData('assets/dark_mode.json').then(_setMapStyle);
          }
        },
        textColor: Colors.white);
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos['latitude'], pos['longitude']),
      zoom: 14.0,
    )));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _animateToUser();
      _mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    toilets.forEach((toilet) async {
      double lat = toilet.geopoint.latitude;
      double lng = toilet.geopoint.longitude;
      MarkerId id = MarkerId(lat.toString() + lng.toString());
      Marker _marker = Marker(
        markerId: id,
        position: LatLng(lat, lng),
        icon: await determineIcon(toilet.category, toilet.openHours, context),
        infoWindow:
            InfoWindow(title: toilet.title, snippet: toilet.price.toString()),
      );
      setState(() {
        markers[id] = _marker;
      });
    });

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(12.960632, 77.641603),
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
    );
  }
}
