import 'package:fluster/fluster.dart';
import './toilet.dart';

class ClusterMarker extends Clusterable {
  Toilet toilet;

  ClusterMarker({
    latitude,
    longitude,
    this.toilet,
    isCluster = false,
    clusterId,
    pointsSize,
    markerId,
    childMarkerId,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          markerId: markerId,
          childMarkerId: childMarkerId,
        );
}
