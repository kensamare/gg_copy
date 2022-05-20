import 'package:gg_copy/models/comments_model.dart';
import 'package:gg_copy/models/data_model.dart';
import 'package:gg_copy/models/likes_model.dart';
import 'package:gg_copy/models/user_model.dart';

class PostModel {
  int? id;
  String? url;
  String? postUrl;
  List<String>? media;
  String? text;
  int? filter;
  int? createdAt;
  int? w;
  int? h;
  List<String>? media250;
  List<String>? media100;
  UserModel? user;
  LikesModel? likes;
  int? liked;
  CommentsModel? comments;
  int? canDelete;
  int? canFollow;
  int? repost;
  int? repostId;
  UserModel? repostUser;
  String? repostComment;

  List<String>? links;
  late bool isFavorites;

  PostModel(
      {this.id,
      this.url,
      this.postUrl,
      this.media,
      this.text,
      this.filter,
      this.createdAt,
      this.w,
      this.h,
      this.media250,
      this.media100,
      this.user,
      this.likes,
      this.liked,
      this.comments,
      this.canDelete,
      this.canFollow,
      this.links,
      this.isFavorites = false,
      this.repost,
      this.repostUser,
      this.repostComment,
      this.repostId});

  PostModel.fromJson(Map<String, dynamic> json) {
    isFavorites = false;
    id = json['id'];
    url = json['url'];
    postUrl = json['post_url'];
    w = json['w'];
    h = json['h'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media!.add(v);
      });
    }
    text = json['text'];
    filter = json['filter'];
    createdAt = json['created_at'];
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(v);
      });
    }
    if (json['media_250'] != null) {
      media250 = [];
      json['media_250'].forEach((v) {
        media250!.add(v);
      });
    }
    if (json['media_100'] != null) {
      media100 = [];
      json['media_100'].forEach((v) {
        media100!.add(v);
      });
    }
    user = json['user'] != null ? UserModel?.fromJson(json['user']) : null;
    likes = json['likes'] != null ? LikesModel?.fromJson(json['likes']) : null;
    liked = json['liked'];
    comments = json['comments'] != null
        ? CommentsModel?.fromJson(json['comments'])
        : null;
    canDelete = json['canDelete'];
    canFollow = json['canFollow'];
    repost = json["repost"];
    if (json["repost_comment"] != null) {
      repostComment = json["repost_comment"];
    }
    if (json["repost_user"] != null) {
      repostUser = UserModel.fromJson(json["repost_user"]);
    }
    repostId = json["repost_id"];
    isFavorites = json['favorite'] != 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['links'] = links;
    json['url'] = url;
    json['post_url'] = postUrl;
    json['media'] = media;
    json['text'] = text;
    json['filter'] = filter;
    json['w'] = w;
    json['h'] = h;
    json['created_at'] = createdAt;
    json['media_250'] = media250;
    json['media_100'] = media100;
    if (user != null) {
      json['user'] = user!.toJson();
    }
    if (likes != null) {
      json['likes'] = likes!.toJson();
    }
    json['liked'] = liked;
    if (comments != null) {
      json['comments'] = comments!.toJson();
    }
    json['canDelete'] = canDelete;
    json['canFollow'] = canFollow;
    json['favorite'] = isFavorites ? 1 : 0;
    json["repost"] = repost;
    json["repost_comment"] = repostComment;
    json["repost_user"] = repostUser;
    json["repost_id"] = repostId;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
