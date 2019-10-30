import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import '../../core/models/toilet.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/common/bitmapFromSvg.dart';

class MapWidget extends StatefulWidget {
  const MapWidget();

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapWidget> {
  MapState();

  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Future<Toilet>> data;
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

  Future<BitmapDescriptor> _determineIcon(
      Category category, List<int> openHours) async {
    String result = "";

    switch (category) {
      case Category.GENERAL:
        result += "general";
        break;
      case Category.SHOP:
        result += "shop";
        break;
      case Category.RESTAURANT:
        result += "restaurant";
        break;
      case Category.GAS_STATION:
        result += "gas_station";
        break;
      case Category.PORTABLE:
        result += "portable";
        break;
      default:
        result += "general";
        break;
    }

    // TODO: determine the open time based on the input array once Balazs is finished.
    result += "_open";

    return await bitmapDescriptorFromSvgAsset(
        context, 'assets/icons/pin/$result.svg');
  }

  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);

    return StreamBuilder(
        stream: toiletProvider.fetchQueriedData(10.0),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data.map((doc) async {
              final toilet = Toilet.fromMap(doc.data, doc.documentID);
              double lat = toilet.geopoint.latitude;
              double lng = toilet.geopoint.longitude;
              MarkerId id = MarkerId(lat.toString() + lng.toString());
              Marker _marker = Marker(
                markerId: id,
                position: LatLng(lat, lng),
                icon: await _determineIcon(toilet.category, toilet.openHours),
                infoWindow: InfoWindow(
                    title: toilet.title, snippet: toilet.price.toString()),
              );
              markers[id] = _marker;
              return toilet;
            }).toList();
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
          } else {
            return Text('fetching');
          }
        });
  }
}
