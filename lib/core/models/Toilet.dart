import 'dart:math';

import 'Note.dart';

enum Category { GENERAL, SHOP, RESTAURANT, PORTABLE, GAS_STATION }
enum Tag {
  WHEELCHAIR_ACCESSIBLE,
  BABY_ROOM,
}
enum EntryMethod { FREE, CODE, PRICE, CONSUMERS, UNKNOWN }

class Toilet {
  String id;
  String name;
  DateTime addDate;
  Category category;
  List<int> openHours;
  List<Tag> tags;

  EntryMethod entryMethod;
  Map price;
  String code;

  double latitude;
  double longitude;

  List<Note> notes;
  Map<String, int> votes;

  int distance = 0;

  Toilet(
    String id,
    String name,
    DateTime addDate,
    Category category,
    List<int> openHours,
    List<Tag> tags,
    EntryMethod entryMethod,
    Map price,
    String code,
    double latitude,
    double longitude,
    List<Note> notes,
    Map<String, int> votes,
  ) {
    this.id = id;
    this.name = name;
    this.addDate = addDate;
    this.category = category;
    this.openHours = openHours;
    this.tags = tags;

    this.entryMethod = entryMethod;
    this.price = price;
    this.code = code;

    this.latitude = latitude;
    this.longitude = longitude;

    this.notes = notes;
    this.votes = votes;
  }

  // Named constructor
  Toilet.origin() {
    name = "";
    addDate = new DateTime.now();
    category = Category.GENERAL;
    openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    tags = [];

    entryMethod = EntryMethod.UNKNOWN;

    latitude = 0.0;
    longitude = 0.0;

    notes = new List<Note>();
    votes = new Map<String, int>();
  }

  Toilet.fromMap(Map raw)
      : id = raw["id"] ?? "",
        name = raw["name"] ?? "",
        latitude = raw["location"]["latitude"] ?? 0.0,
        longitude = raw["location"]["longitude"] ?? 0.0,
        category =
            _standariseCategory(raw["category"].toString()) ?? Category.GENERAL,
        openHours = raw["openHours"].cast<int>() ??
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tags = raw["tags"] != null ? _standariseTags(raw["tags"]) : [],
        notes = raw["notes"] != null
            ? _standariseNotes(raw["notes"])
            : new List<Note>(),
        votes = raw["votes"] != null
            ? _standariseVotes(raw["votes"])
            : new Map<String, int>(),
        entryMethod = _standariseEntryMethod(raw["entryMethod"].toString()) ??
            EntryMethod.UNKNOWN,
        price = raw["price"] != null && raw["price"] != 0
            ? Map.from(raw["price"])
            : null,
        code = raw["code"] ?? null,
        addDate = DateTime.parse(raw["addDate"]) ?? new DateTime.now();

  int calculateDistance(double userLatitude, double userLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((userLatitude - latitude) * p) / 2 +
        c(latitude * p) * c(userLatitude * p) * (1 - c((userLongitude - longitude) * p)) / 2;

    int distance = ((12742 * asin(sqrt(a))) * 1000).round();
    this.distance = distance;

    return distance;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "addDate": addDate.toString(),
      "category":
          "${category.toString().substring(category.toString().indexOf('.') + 1)}",
      "openHours": openHours,
      "tags": {
        "WHEELCHAIR_ACCESSIBLE": tags.contains(Tag.WHEELCHAIR_ACCESSIBLE),
        "BABY_ROOM": tags.contains(Tag.BABY_ROOM)
      },
      "entryMethod": entryMethod != null
          ? "${entryMethod.toString().substring(entryMethod.toString().indexOf('.') + 1)}"
          : null,
      "price": price["HUF"] != null ? price : null,
      "code": code,
      "location": {
        "latitude": latitude,
        "longitude": longitude,
      },
      "notes": notes.map((Note note) => note.toJson()).toList(),
      "votes": votes.toString(),
    };
  }

  static Map<String, int> _standariseVotes(Map<dynamic, dynamic> input) {
    if (input != null) {
      return Map<String, int>.from(input);
    }
    return new Map<String, int>();
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
        if (value == true) {
          switch (tag) {
            case "WHEELCHAIR_ACCESSIBLE":
              {
                _tags.add(Tag.WHEELCHAIR_ACCESSIBLE);
                break;
              }
            case "BABY_ROOM":
              {
                _tags.add(Tag.BABY_ROOM);
                break;
              }
          }
        }
      });
    }
    return _tags;
  }

  static List<Note> _standariseNotes(List<dynamic> input) {
    List<Note> _notes = [];
    if (input != null) {
      input.forEach((dynamic val) {
        _notes.add(Note.fromMap(val));
      });
    }
    _notes.sort((a, b) => b.addDate.compareTo(a.addDate));
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Toilet &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          distance == other.distance;
}
