class Note {
  DateTime addDate;
  String text;
  String userId;

  // Default constructor
  Note(String text, String uid) {
    addDate = new DateTime.now();
    this.text = text;
    this.userId = uid;
  }

  Note.fromMap(Map snapshot)
      : text = snapshot["text"] ?? "",
        userId = snapshot["userId"] ?? "",
        addDate = DateTime.parse(snapshot["addDate"]) ?? new DateTime.now();

  toJson() {
    return {"addDate": addDate.toString(), "text": text, "userId": userId};
  }
}
