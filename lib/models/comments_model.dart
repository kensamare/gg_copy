import 'post_model.dart';
import 'comment_data_model.dart';

class CommentsModel {
  int? count;
  List<CommentDataModel>? data;

  CommentsModel({this.count, this.data});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CommentDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['count'] = count;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
