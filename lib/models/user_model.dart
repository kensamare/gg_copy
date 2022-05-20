class UserModel {
  int? id;
  String? nickname;
  String? avatar;
  String? avatar250;
  String? avatar100;

  UserModel(
      {this.id, this.nickname, this.avatar, this.avatar250, this.avatar100});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    avatar250 = json['avatar_250'];
    avatar100 = json['avatar_100'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['nickname'] = nickname;
    json['avatar'] = avatar;
    json['avatar_250'] = avatar250;
    json['avatar_100'] = avatar100;
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
