import 'poem_model.dart';

class SelfModel {
  int? id;
  String? nickname;
  String? avatar;
  String? name;
  String? about;
  String? avatar250;
  String? avatar100;
  int? posts;
  int? follow;
  int? followers;
  PoemModel? poem;
  int? currentUser;
  int? canFollow;
  int? blocked;
  int? best;

  SelfModel({
    this.id,
    this.nickname,
    this.avatar,
    this.name,
    this.about,
    this.avatar250,
    this.avatar100,
    this.posts,
    this.follow,
    this.followers,
    this.poem,
    this.currentUser,
    this.canFollow,
    this.blocked,
    this.best
  });

  SelfModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    name = json['name'];
    about = json['about'];
    avatar250 = json['avatar_250'];
    avatar100 = json['avatar_100'];
    posts = json['posts'];
    follow = json['follow'];
    followers = json['followers'];
    poem = json['poem'] != null ? PoemModel?.fromJson(json['poem']) : null;
    currentUser = json['currentUser'];
    canFollow = json['canFollow'];
    blocked = json['blocked'];
    best = json['best'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['nickname'] = nickname;
    json['avatar'] = avatar;
    json['name'] = name;
    json['about'] = about;
    json['avatar_250'] = avatar250;
    json['avatar_100'] = avatar100;
    json['posts'] = posts;
    json['follow'] = follow;
    json['followers'] = followers;
    if (poem != null) {
      json['poem'] = poem!.toJson();
    }
    json['currentUser'] = currentUser;
    json['canFollow'] = canFollow;
    json['best'] = best;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
