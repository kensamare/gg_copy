import 'dart:convert';

import 'package:http/http.dart' as http;

class Posts {
  static Future<List?> getFeedPosts(
    String token,
    int? offset,
    int? offsetPostId,
  ) async {
    Uri url;
    if (offset != null) {
      url =
          Uri.parse('https://api.grustnogram.ru/posts?limit=10&offset=$offset');
    } else {
      url = Uri.parse(
          'https://api.grustnogram.ru/posts?limit=10&offset_post_id=$offsetPostId');
    }
    var response = await http.get(url, headers: {
      'Access-Token': token,
    });
    return json.decode(response.body)['data'];
  }

  static Future<List?> getUserFeedPosts(
    String token,
    int? offset,
    dynamic idUser,
  ) async {
    Uri url =
        Uri.parse('https://api.grustnogram.ru/posts?limit=10&offset=$offset&id_user=$idUser');
    var response = await http.get(url, headers: {
      'Access-Token': token,
    });
    return json.decode(response.body)['data'];
  }

  static Future<void> like(int? id, String token) async {
    var url = Uri.parse('https://api.grustnogram.ru/posts/$id/like');
    await http.post(url, headers: {
      'Access-Token': token,
    });
  }

  static Future<void> dislike(int? id, String token) async {
    var url = Uri.parse('https://api.grustnogram.ru/posts/$id/like');
    await http.delete(url, headers: {
      'Access-Token': token,
    });
  }

  static Future comment(String token, int? id, String text) async {
    var url = Uri.parse('https://api.grustnogram.ru/posts/$id/comments');
    var response = await http.post(
      url,
      headers: {
        'Access-Token': token,
      },
      body: jsonEncode(
        {
          'comment': text,
        },
      ),
    );
    return jsonDecode(response.body)['data'];
  }

  static Future getNewComments(String token, int? id, int offset) async {
    var url = Uri.parse(
        'https://api.grustnogram.ru/posts/$id/comments?limit=10&offset=$offset');
    var response = await http.get(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body)['data'];
  }

  static Future getNewLikes(String token, int? id, int offset) async {
    var url = Uri.parse(
        'https://api.grustnogram.ru/posts/$id/likes?limit=20&offset=$offset');
    var response = await http.get(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body)['data'];
  }

  static Future getSearchedUsers(String token, String searchValue) async {
    var url = Uri.parse(
        'https://api.grustnogram.ru/users?q=$searchValue');
    var response = await http.get(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body)['data'];
  }

  static Future getSelfData(String token) async {
    var url = Uri.parse('https://api.grustnogram.ru/users/self');
    var response = await http.get(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body)['data'];
  }

  static Future<Map> getUserData(String token, dynamic nickname) async {
    var url = Uri.parse('https://api.grustnogram.ru/users/$nickname');
    var response = await http.get(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body)['data'];
  }

  static Future follow(String token, dynamic id) async {
    var url = Uri.parse('https://api.grustnogram.ru/users/$id/follow');
    var response = await http.post(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body);
  }

  static Future unfollow(String token, dynamic id) async {
    var url = Uri.parse('https://api.grustnogram.ru/users/$id/follow');
    var response = await http.delete(
      url,
      headers: {
        'Access-Token': token,
      },
    );
    return jsonDecode(response.body);
  }
}
