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
  Map<String, int> votes;
  int distance = 0;

  EntryMethod entryMethod;
  Map price;
  String code;

  Toilet(
    String id,
    GeoFirePoint geopoint,
    String title,
    DateTime addDate,
    Category category,
    List<int> openHours,
    List<Tag> tags,
    List<Note> notes,
    Map<String, int> votes,
    EntryMethod entryMethod,
    Map price,
    String code,
  ) {
    this.id = id;
    this.geopoint = geopoint;
    this.title = title;
    this.addDate = addDate;
    this.category = category;
    this.openHours = openHours;
    this.tags = tags;
    this.notes = notes;
    this.votes = votes;
    this.entryMethod = entryMethod;
    this.price = price;
    this.code = code;
  }

  // Named constructor
  Toilet.origin() {
    id = new Uuid().v4().toString();
    geopoint = new GeoFirePoint(0, 0);
    title = "";
    addDate = new DateTime.now();
    category = Category.GENERAL;
    openHours = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    tags = [];
    notes = new List<Note>();
    votes = new Map<String, int>();
    entryMethod = EntryMethod.UNKNOWN;
  }

  Toilet.fromMap(Map snapshot, String id)
      : id = id,
        geopoint = new GeoFirePoint(
          snapshot["geopoint"]["geopoint"].latitude,
          snapshot["geopoint"]["geopoint"].longitude,
        ),
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
        votes = snapshot["votes"] != null
            ? _standariseVotes(snapshot["votes"])
            : new Map<String, int>(),
        entryMethod =
            _standariseEntryMethod(snapshot["entryMethod"].toString()) ??
                EntryMethod.UNKNOWN,
        price = snapshot["price"] != null && snapshot["price"] != 0
            ? Map.from(snapshot["price"])
            : null,
        code = snapshot["code"] ?? null,
        addDate = DateTime.parse(snapshot["addDate"]) ?? new DateTime.now();

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
      "Tags": {
        "WHEELCHAIR_ACCESSIBLE": tags.contains(Tag.WHEELCHAIR_ACCESSIBLE),
        "BABY_ROOM": tags.contains(Tag.BABY_ROOM)
      },
      "notes": notes.map((Note note) => note.toJson()).toList(),
      "votes": votes.toString(),
      "entryMethod": entryMethod != null
          ? "${entryMethod.toString().substring(entryMethod.toString().indexOf('.') + 1)}"
          : null,
      "price": price["HUF"] != null ? price : null,
      "code": code
    };
  }

  static Map<String, int> _standariseVotes(dynamic input) {
    Map<String, int> _votes = new Map<String, int>();
    print(input);
    // TODO: implement converting cloud votes to local votes
    // if (input != null) {
    //   input.forEach((dynamic val) {
    //     print(val);
    //     // _votes.addEntries(newEntries) .add(Note.fromMap(val));
    //   });
    // }
    return _votes;
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
          id == other.id &&
          title == other.title &&
          distance == other.distance;
}
