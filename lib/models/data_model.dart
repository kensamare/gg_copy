class DataModel {
  int? id;
  String? nickname;
  String? comment;
  int? createdAt;
  int? canDelete;

  DataModel(
      {this.id, this.nickname, this.comment, this.createdAt, this.canDelete});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    comment = json['comment'];
    createdAt = json['created_at'];
    canDelete = json['canDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['nickname'] = nickname;
    json['comment'] = comment;
    json['created_at'] = createdAt;
    json['canDelete'] = canDelete;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}