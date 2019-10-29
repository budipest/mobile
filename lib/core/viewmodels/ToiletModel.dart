import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/toilet.dart';
import '../services/api.dart';
import '../../locator.dart';

class ToiletModel extends ChangeNotifier {
  API _api = locator<API>();

  List<Toilet> data;

  Future<List<Toilet>> fetchData() async {
    var result = await _api.getDataCollection();
    data = result.documents
        .map((doc) => Toilet.fromMap(doc.data, doc.documentID))
        .toList();
    return data;
  }

  Stream<List<DocumentSnapshot>> fetchQueriedData(double rad) {
    return _api.streamQueriedData(rad);
  }

  Stream<QuerySnapshot> fetchDataAsStream() {
    return _api.streamDataCollection();
  }

  Future<Toilet> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Toilet.fromMap(doc.data, doc.documentID);
  }

  Future removeProduct(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateProduct(Toilet data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addProduct(Toilet data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
