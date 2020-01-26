import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';

import '../../core/common/bitmapFromSvg.dart';

class AddToiletLocation extends StatefulWidget {
  AddToiletLocation(this.onLocationChanged, this.location);
  final Function onLocationChanged;
  final LatLng location;

  @override
  _AddToiletLocationState createState() =>
      _AddToiletLocationState();
}

class _AddToiletLocationState extends State<AddToiletLocation> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  GoogleMapController _mapController;

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _animateToUser() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 15.0,
    )));
  }

  Future<BitmapDescriptor> getDraggableIcon(BuildContext context) async =>
      await bitmapDescriptorFromSvgAsset(
        context,
        'assets/icons/pin/l_general_unknown.svg',
      );

  void _setMapStyle(String mapStyle) {
    setState(() {
      _mapController.setMapStyle(mapStyle);
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    double lat = widget.location.latitude;
    double lng = widget.location.longitude;
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: widget.location,
      draggable: true,
      onDragEnd: widget.onLocationChanged,
      icon: await getDraggableIcon(context),
    );
    setState(() {
      _mapController = controller;
      markers[id] = _marker;
      _animateToUser();
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.location.latitude,
          widget.location.longitude,
        ),
        zoom: 16.0,
      ),
      compassEnabled: true,
      mapType: MapType.normal,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(markers.values),
    );
  }
}
