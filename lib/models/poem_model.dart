class PoemModel {
  String? title;
  String? poem;
  String? author;
  String? avatar;
  int? year;

  PoemModel({this.title, this.poem, this.author, this.avatar, this.year});

  PoemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    poem = json['poem'];
    author = json['author'];
    avatar = json['avatar'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['title'] = title;
    json['poem'] = poem;
    json['author'] = author;
    json['avatar'] = avatar;
    json['year'] = year;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
