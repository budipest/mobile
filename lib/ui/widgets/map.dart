import 'package:flutter/material.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';

import '../../core/models/toilet.dart';
import '../../core/models/clusterMarker.dart';
import '../../core/common/determineIcon.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.toilets, this.userLocation, this.selectToilet);

  final List<Toilet> toilets;
  final Map userLocation;
  final Function(Toilet) selectToilet;

  @override
  State<StatefulWidget> createState() =>
      MapState(toilets, userLocation, selectToilet);
}

class MapState extends State<MapWidget> {
  MapState(this.toilets, this.userLocation, this.selectToilet);

  final Function(Toilet) selectToilet;
  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Toilet> toilets;
  bool _nightMode = false;
  BitmapDescriptor generalOpen;
  Map userLocation;

  // List<ClusterMarker> rawMarkers = toilets.map((Toilet data) => {
  //   return ClusterMarker()
  // }).toList();
  // Fluster<ClusterMarker> fluster = Fluster<ClusterMarker>(
  //     minZoom: 0,
  //     maxZoom: 20,
  //     radius: 150,
  //     extent: 2048,
  //     nodeSize: 64,
  //     points: markers,
  //     createCluster: (BaseCluster cluster, double longitude, double latitude) {
  //       return ClusterMarker(
  //           markerId: cluster.id.toString(),
  //           latitude: latitude,
  //           longitude: longitude,);
  //     });

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
    toilets.forEach((toilet) async {
      double lat = toilet.geopoint.latitude;
      double lng = toilet.geopoint.longitude;
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
      setState(() {
        markers[id] = _marker;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  _animateToUser() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(userLocation["latitude"], userLocation["longitude"]),
      zoom: 15.0,
    )));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _animateToUser();
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      onTap: (LatLng coords) => selectToilet(null),
    );
  }
}
