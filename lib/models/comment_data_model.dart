import 'package:gg_copy/models/comment_replies_model.dart';

class CommentDataModel {
  int? id;
  String? nickname;
  String? comment;
  int? createdAt;
  int? canDelete;
  List<String>? links;
  int? likes;
  int? liked;
  int? repliesCount;
  String? avatar;
  List<CommentRepliesModel>? replies;

  CommentDataModel(
      {this.id, this.nickname, this.comment, this.createdAt, this.canDelete, this.links, this.liked, this.likes, this.repliesCount, this.replies, this.avatar});

  CommentDataModel.fromJson(Map<String, dynamic> json) {
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
    replies = [];
    if (json['replys'] != null) {
      json['replys'].forEach((v) {
        replies!.add(CommentRepliesModel.fromJson(v));
      });
    }
    repliesCount = json['replys_count'];
    createdAt = json['created_at'];
    likes = json['likes'];
    canDelete = json['canDelete'];
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (replies != null) {
      json['replys'] = replies!.map((v) => v.toJson()).toList();
    }
    json['replys_count'] = repliesCount;
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
