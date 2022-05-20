class NotificationsModel {
  int? id;
  String? type;
  int? idPost;
  Data? data;
  int? createdAt;

  NotificationsModel(
      {this.id, this.type, this.idPost, this.data, this.createdAt});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    idPost = json['id_post'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['id_post'] = this.idPost;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Data {
  String? text;
  String? nickname;
  String? avatar;
  String? postUrl;
  String? postImg;
  String? read;

  Data(
      {this.text,
        this.nickname,
        this.avatar,
        this.postUrl,
        this.postImg,
        this.read});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    postUrl = json['post_url'];
    postImg = json['post_img'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['post_url'] = this.postUrl;
    data['post_img'] = this.postImg;
    data['read'] = this.read;
    return data;
  }
}