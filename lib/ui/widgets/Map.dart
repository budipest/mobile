import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';
import '../../core/services/API.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    this.onMapCreated,
    this.key,
  });

  final Function onMapCreated;
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

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  drawRoutes(
    double userLat,
    double userLon,
    double toiletLat,
    double toiletLon,
  ) async {
    final encodedPoly =
        await API.getRouteCoordinates(userLat, userLon, toiletLat, toiletLon);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId(LatLng(userLat, userLon).toString()),
          width: 4,
          points: _convertToLatLng(_decodePoly(encodedPoly)),
          color: Colors.black,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller, BuildContext context) {
    setState(() {
      mapController = controller;
      _getFileData('assets/light_mode.json').then(_setMapStyle);
    });

    widget.onMapCreated();
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
