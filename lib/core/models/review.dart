class Review {
  DateTime addDate;
  String title;
  int rating;
  String userId;

  // Default constructor
  Review(this.addDate, this.title, this.rating, this.userId);

  // Named constructor
  Review.origin() {
    addDate = new DateTime.now();
    title = "";
    rating = 0;
    userId = "";
  }

  toJson() {
    return {
      "addDate": addDate.toString(),
      "title": title,
      "rating": rating,
      "userId": userId
    };
  }
}
