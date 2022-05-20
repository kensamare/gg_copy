import 'user_model.dart';

class LikesModel {
  int? count;
  List<UserModel>? users;

  LikesModel({this.count, this.users});

  LikesModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users!.add(UserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['count'] = count;
    if (users != null) {
      json['users'] = users!.map((v) => v.toJson()).toList();
    }
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
