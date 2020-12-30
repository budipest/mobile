import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/common/bitmapFromSvg.dart';

class AddToiletLocation extends StatefulWidget {
  AddToiletLocation(
    this.onLocationChanged,
    this.location,
  );

  final Function onLocationChanged;
  final LatLng location;

  @override
  _AddToiletLocationState createState() => _AddToiletLocationState();
}

class _AddToiletLocationState extends State<AddToiletLocation> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  GoogleMapController _mapController;

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _animateToLocation() {
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
      markers = <MarkerId, Marker>{};
      markers[id] = _marker;
      _animateToLocation();
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
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
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          indoorViewEnabled: true,
          buildingsEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: Set<Marker>.of(markers.values),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  offset: Offset(0, 2.5),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(
              FlutterI18n.translate(context, "drag-marker"),
              style: TextStyle(fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
