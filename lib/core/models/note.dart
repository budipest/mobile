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

  toJson() {
    return {
      "addDate": addDate.toString(),
      "text": text,
      "userId": userId
    };
  }
}
