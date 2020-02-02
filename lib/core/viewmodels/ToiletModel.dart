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

  Stream<List<DocumentSnapshot>> fetchQueriedData(
      double rad, double lat, double lon) {
    return _api.streamQueriedData(rad, lat, lon);
  }

  Stream<QuerySnapshot> fetchDataAsStream() {
    return _api.streamDataCollection();
  }

  Stream<List<Toilet>> streamToilets() {
    return _api.streamDataCollection().map((list) => list.documents
        .map((f) {
          if (f.data["geopoint"] != null) {
            return Toilet.fromMap(f.data, f.documentID);
          } else {
            print(f.documentID);
            return null;
          }
        })
        .cast<Toilet>()
        .toList());
  }

  Future uploadToilet(Toilet data) async {
    var result = await _api.addDocument(data.toJson());

    return result;
  }
}
