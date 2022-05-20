class CommentRepliesModel {
  int? id;
  String? nickname;
  String? comment;
  int? createdAt;
  int? canDelete;
  List<String>? links;
  int? likes;
  int? liked;
  String? avatar;

  CommentRepliesModel(
      {this.id,
        this.nickname,
        this.comment,
        this.createdAt,
        this.canDelete,
        this.links,
        this.liked,
        this.likes,});

  CommentRepliesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    comment = json['comment'];
    avatar = json['avatar'];

    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(v);
      });
    }
    createdAt = json['created_at'];
    likes = json['likes'];
    canDelete = json['canDelete'];
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['avatar'] = avatar;
    json['id'] = id;
    json['nickname'] = nickname;
    json['comment'] = comment;
    json['links'] = links;
    json['created_at'] = createdAt;
    json['likes'] = likes;
    json['canDelete'] = canDelete;
    json['liked'] = liked;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
