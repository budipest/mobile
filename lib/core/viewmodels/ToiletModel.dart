import 'package:flutter/foundation.dart';

import '../models/Toilet.dart';
import '../services/api.dart';
import '../../locator.dart';

class ToiletModel extends ChangeNotifier {
  API _api = locator<API>();

  List<Toilet> data;

  // Future<List<Toilet>> fetchData() async {
  //   var result = await _api.getDataCollection();
  //   data = result.documents
  //       .map((doc) => Toilet.fromMap(doc.data, doc.documentID))
  //       .toList();
  //   return data;
  // }

  // Stream<List<DocumentSnapshot>> fetchQueriedData(
  //     double rad, double lat, double lon) {
  //   return _api.streamQueriedData(rad, lat, lon);
  // }

  // Stream<QuerySnapshot> fetchDataAsStream() {
  //   return _api.streamDataCollection();
  // }

  // Future uploadToilet(Toilet data) async {
  //   var result = await _api.addDocument(data.toJson());

  //   return result;
  // }
}
