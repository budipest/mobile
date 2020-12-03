class Vote {
  String userId;
  int value;

  Vote(this.userId, this.value);

  Vote.fromMap(Map snapshot)
      : userId = snapshot["userId"],
        value = snapshot["value"];

  toJson() {
    return {"userId": userId, "value": value};
  }
}
