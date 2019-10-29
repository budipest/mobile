import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class API {
  final Firestore _db = Firestore.instance;
  final String path;

  CollectionReference ref;

  Geoflutterfire _geo;
  GeoFirePoint center;
  GeoFireCollectionRef _geoRef;


  API(this.path) {
    ref = _db.collection(path);
    _geo = Geoflutterfire();
    center = _geo.point(latitude: 47.496430, longitude: 19.043793);
    _geoRef = _geo.collection(collectionRef: ref);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<List<DocumentSnapshot>> streamQueriedData(double rad) {
    return _geoRef.within(
        center: center, radius: rad, field: 'geopoint', strictMode: true);
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }
}
