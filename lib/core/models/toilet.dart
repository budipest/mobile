import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:uuid/uuid.dart';

import './review.dart';

enum Category { GENERAL, SHOP, RESTAURANT, PORTABLE, GAS_STATION }
enum Tag {
  WHEELCHAIR_ACCESSIBLE,
}

class Toilet {
  String id;
  GeoFirePoint geopoint;
  int price;
  String title;
  DateTime addDate;
  Category category;
  List<int> openHours;
  List<Tag> tags;
  List<Review> reviews;
  int upvotes;
  int downvotes;
  int distance = 0;

  // Default constructor
  Toilet(this.id, this.geopoint, this.price, this.title, this.addDate,
      this.category, this.openHours, this.tags, this.reviews);

  // Named constructor
  Toilet.origin() {
    id = new Uuid().toString();
    geopoint = new GeoFirePoint(0, 0);
    price = 0;
    title = "";
    addDate = new DateTime.now();
    category = Category.GENERAL;
    openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    tags = [];
    reviews = [];
    upvotes = 0;
    downvotes = 0;
  }

  // TODO: remove the comments when Balazs is finished with his Firebase card
  Toilet.fromMap(Map snapshot, String id)
      : id = snapshot["id"] ?? id,
        geopoint = new GeoFirePoint(snapshot["geopoint"]["geopoint"].latitude,
            snapshot["geopoint"]["geopoint"].longitude),
        price = snapshot["price"] ?? 0,
        title = snapshot["title"] ?? "",
        category = _standariseCategory(snapshot["category"].toString()) ??
            Category.GENERAL,
        openHours = snapshot["openHours"].cast<int>() ??
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tags = _standariseTags(snapshot["tags"].toString()) ?? [],
        reviews = _standariseReviews(snapshot["reviews"].toString()) ??
            new List<Review>(),
        upvotes = snapshot["upvotes"] != null ? snapshot["upvotes"] : 0,
        downvotes = snapshot["downvotes"] != null ? snapshot["downvotes"] : 0;

  int calculateDistance(pos) {
    int dist =
        (this.geopoint.distance(lat: pos["latitude"], lng: pos["longitude"]) *
                1000)
            .toInt();
    this.distance = dist;
    return dist;
  }

  toJson() {
    return {
      "id": id,
      "geopoint": geopoint.data,
      "price": price,
      "title": title,
      "addDate": addDate.toString(),
      "category":
          "${category.toString().substring(category.toString().indexOf('.') + 1)}",
      "openHours": openHours,
      "tags": tags
          .map((Tag tag) =>
              "${tag.toString().substring(tag.toString().indexOf('.') + 1)}")
          .toList(),
      "reviews": reviews.map((Review review) => review.toJson()).toList(),
      "upvotes": upvotes,
      "downvotes": downvotes
    };
  }

  static Category _standariseCategory(String input) {
    switch (input) {
      case "GENERAL":
        return Category.GENERAL;
      case "SHOP":
        return Category.SHOP;
      case "RESTAURANT":
        return Category.RESTAURANT;
      case "PORTABLE":
        return Category.PORTABLE;
      case "GAS_STATION":
        return Category.GAS_STATION;
      default:
        return Category.GENERAL;
    }
  }

  static List<Tag> _standariseTags(String input) {
    List<Tag> _tags = [];
    return _tags;
  }

  static List<Review> _standariseReviews(String input) {
    List<Review> _reviews = [];
    return _reviews;
  }
}
