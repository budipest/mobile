import 'package:geoflutterfire/geoflutterfire.dart';
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

  // Default constructor
  Toilet(this.id, this.geopoint, this.price, this.title, this.addDate,
      this.category, this.openHours, this.tags, this.reviews);

  // Named constructor
  Toilet.origin() {
    id = "";
    geopoint = new GeoFirePoint(0, 0);
    price = 0;
    title = "";
    addDate = new DateTime.now();
    category = Category.GENERAL;
    openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    tags = [];
    reviews = [];
  }

  // TODO: remove the comments when Balazs is finished with his Firebase card
  Toilet.fromMap(Map snapshot, String id)
      : id = snapshot["id"] ?? "",
        geopoint = new GeoFirePoint(snapshot["geopoint"]["geopoint"].latitude,
            snapshot["geopoint"]["geopoint"].longitude),
        price = snapshot["price"] ?? 0,
        title = snapshot["title"] ?? "",
        addDate = /*snapshot["addDate"] ??*/ new DateTime.now(),
        category = _standariseCategory(snapshot["category"].toString()) ??
            Category.GENERAL,
        openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tags = _standariseTags(snapshot["tags"].toString()) ?? new List<Tag>(),
        reviews = _standariseReviews(snapshot["reviews"].toString()) ??
            new List<Review>();

  toJson() {
    return {
      "id": id,
      "geopoint": geopoint.data,
      "price": price,
      "title": title,
      "addDate": addDate.toString(),
      "category": category.toString(),
      "openHours": openHours,
      "tags": tags.map((Tag tag) => tag.toString()).toList(),
      "reviews": reviews.map((Review review) => review.toJson()).toList(),
    };
  }

  static Category _standariseCategory(String input) {
    switch (input) {
      case "General":
        return Category.GENERAL;
      case "Shop":
        return Category.SHOP;
      case "Restaurant":
        return Category.RESTAURANT;
      case "Portable":
        return Category.PORTABLE;
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
