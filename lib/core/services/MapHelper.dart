import 'dart:async';
import 'dart:ui';

import "../models/Toilet.dart";
import "../providers/ToiletModel.dart";

import 'package:provider/provider.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class MapMarker extends Clusterable {
  final String id;
  final Toilet toilet;
  final LatLng position;
  BitmapDescriptor icon;

  MapMarker({
    @required this.id,
    @required this.position,
    this.toilet,
    this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker(BuildContext context) => Marker(
        markerId: MarkerId(isCluster ? 'cl_$id' : id),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: icon,
        onTap: () {
          if (isCluster) {
            // TODO: zoom in to the map
          } else {
            Provider.of<ToiletModel>(context, listen: false)
                .selectToilet(toilet);
          }
        },
      );
}

class MapHelper {
  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
    int clusterSize,
    Color clusterColor,
    Color textColor,
    int width,
  ) async {
    assert(clusterSize != null);
    assert(clusterColor != null);
    assert(width != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  /// Inits the cluster manager with all the [MapMarker] to be displayed on the map.
  /// Here we're also setting up the cluster marker itself, also with an [clusterImageUrl].
  ///
  /// For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
  ) async {
    assert(markers != null);

    return Fluster<MapMarker>(
      minZoom: 8,
      maxZoom: 20,
      radius: 500,
      extent: 2048,
      nodeSize: 1,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        id: cluster.id.toString(),
        position: LatLng(lat, lng),
        isCluster: cluster.isCluster,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double zoom,
    LatLngBounds bounds,
    BuildContext context,
  ) {
    assert(zoom != null);
    assert(bounds != null);

    if (clusterManager == null) return Future.value([]);

    return Future.wait(
      clusterManager.clusters(
        [
          bounds.southwest.longitude - 0.025,
          bounds.southwest.latitude - 0.025,
          bounds.northeast.longitude + 0.025,
          bounds.northeast.latitude + 0.025,
        ],
        zoom.toInt(),
      ).map((mapMarker) async {
        if (mapMarker.isCluster) {
          mapMarker.icon = await _getClusterMarker(
            mapMarker.pointsSize,
            Colors.black,
            Colors.white,
            80,
          );
        }

        return mapMarker.toMarker(context);
      }).toList(),
    );
  }
}
