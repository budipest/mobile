import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:uuid/uuid.dart';

import './note.dart';

enum Category { GENERAL, SHOP, RESTAURANT, PORTABLE, GAS_STATION }
enum Tag {
  WHEELCHAIR_ACCESSIBLE,
  BABY_ROOM,
}
enum EntryMethod { FREE, CODE, PRICE, CONSUMERS, UNKNOWN }

class Toilet {
  String id;
  GeoFirePoint geopoint;
  String title;
  DateTime addDate;
  Category category;
  List<int> openHours;
  List<Tag> tags;
  List<Note> notes;
  int upvotes;
  int downvotes;
  int distance = 0;

  EntryMethod entryMethod;
  Map price;
  String code;

  // Named constructor
  Toilet.origin() {
    id = new Uuid().toString();
    geopoint = new GeoFirePoint(0, 0);
    title = "";
    addDate = new DateTime.now();
    category = Category.GENERAL;
    openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    tags = [];
    notes = new List<Note>();
    upvotes = 0;
    downvotes = 0;
    entryMethod = EntryMethod.UNKNOWN;
  }

  Toilet.fromMap(Map snapshot, String id)
      : id = snapshot["id"] ?? id,
        geopoint = new GeoFirePoint(snapshot["geopoint"]["geopoint"].latitude,
            snapshot["geopoint"]["geopoint"].longitude),
        title = snapshot["title"] ?? "",
        category = _standariseCategory(snapshot["category"].toString()) ??
            Category.GENERAL,
        openHours = snapshot["openHours"].cast<int>() ??
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tags =
            snapshot["Tags"] != null ? _standariseTags(snapshot["Tags"]) : [],
        notes = snapshot["notes"] != null
            ? _standariseNotes(snapshot["notes"])
            : new List<Note>(),
        upvotes = snapshot["upvotes"] != null ? snapshot["upvotes"] : 0,
        downvotes = snapshot["downvotes"] != null ? snapshot["downvotes"] : 0,
        entryMethod =
            _standariseEntryMethod(snapshot["entryMethod"].toString()) ??
                EntryMethod.UNKNOWN,
        price = snapshot["price"] != null && snapshot["price"] != 0
            ? Map.from(snapshot["price"])
            : null,
        code = snapshot["code"] ?? null;

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
      "title": title,
      "addDate": addDate.toString(),
      "category":
          "${category.toString().substring(category.toString().indexOf('.') + 1)}",
      "openHours": openHours,
      "tags": tags
          .map((Tag tag) =>
              "${tag.toString().substring(tag.toString().indexOf('.') + 1)}")
          .toList(),
      "notes": notes.map((Note note) => note.toJson()).toList(),
      "upvotes": upvotes,
      "downvotes": downvotes,
      "entryMethod":
          "${entryMethod.toString().substring(entryMethod.toString().indexOf('.') + 1)}",
      "price": price,
      "code": code
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

  static List<Tag> _standariseTags(Map input) {
    List<Tag> _tags = [];
    if (input != null) {
      input.forEach((dynamic tag, dynamic value) {
        switch (tag) {
          case "WHEELCHAIR_ACCESSIBLE":
            {
              if (value == true) _tags.add(Tag.WHEELCHAIR_ACCESSIBLE);
              break;
            }
          case "BABY_ROOM":
            {
              if (value == true) _tags.add(Tag.BABY_ROOM);
              break;
            }
        }
      });
    }
    return _tags;
  }

  static List<Note> _standariseNotes(Map input) {
    List<Note> _notes = [];
    return _notes;
  }

  static EntryMethod _standariseEntryMethod(String input) {
    switch (input) {
      case "FREE":
        return EntryMethod.FREE;
      case "PRICE":
        return EntryMethod.PRICE;
      case "CONSUMERS":
        return EntryMethod.CONSUMERS;
      case "CODE":
        return EntryMethod.CODE;
      default:
        return EntryMethod.UNKNOWN;
    }
  }
}
