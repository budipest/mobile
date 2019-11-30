class Note {
  DateTime addDate;
  String title;
  String userId;

  // Default constructor
  Note(this.addDate, this.title, this.userId);

  // Named constructor
  Note.origin() {
    addDate = new DateTime.now();
    title = "";
    userId = "";
  }

  toJson() {
    return {
      "addDate": addDate.toString(),
      "title": title,
      "userId": userId
    };
  }
}
