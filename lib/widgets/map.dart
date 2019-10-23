import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'dart:async';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MapWidget extends StatefulWidget {
  const MapWidget();

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapWidget> {
  MapState();

  GoogleMapController _mapController;

  // firestore init
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(
      1000.0); // TODO: change this to the map zoom level!
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location location = new Location();
  bool _nightMode = false;
  // ------------------------------------------------------------------------------------------

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

    geo = Geoflutterfire();
    // TODO: remove this hack and move it to the user's location!!!
    GeoFirePoint center = geo.point(latitude: 47.496430, longitude: 19.043793);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('locations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);

      /*
      ****Example to specify nested object****
      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');
      */
    });
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList.length);
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
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
      _getFileData('assets/dark_mode.json').then(_setMapStyle);
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        print("Change is in the air!");
        _updateMarkers(documentList);
      });
    });
  }

  void _addMarker(double lat, double lng) {
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  @override
  Widget build(BuildContext context) {
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
