import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class API {
  final Firestore _db = Firestore.instance;
  final String path;

  CollectionReference ref;

  Geoflutterfire _geo;
  GeoFireCollectionRef _geoRef;

  API(this.path) {
    ref = _db.collection(path);
    _geo = Geoflutterfire();
    _geoRef = _geo.collection(collectionRef: ref);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<List<DocumentSnapshot>> streamQueriedData(
      double rad, double lat, double lon) {
    return _geoRef.within(
      center: _geo.point(latitude: lat, longitude: lon),
      radius: rad,
      field: 'geopoint',
      strictMode: true,
    );
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

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.document(id).updateData(data);
  }

  Future<void> addToArray(List data, String id, String field) {
    return ref.document(id).updateData({field: FieldValue.arrayUnion(data)});
  }

  Future<void> removeFromArray(List data, String id, String field) {
    return ref.document(id).updateData({field: FieldValue.arrayRemove(data)});
  }
}
