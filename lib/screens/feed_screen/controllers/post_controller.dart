import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/models/user_model.dart';
import 'package:gg_copy/project_utils/api_util.dart';
import 'package:gg_copy/project_utils/singletons/sg_follows.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';

class PostController extends GetxController {
  List<PostModel> posts = [];
  // List<String> follows = [];
  SelfModel user = SelfModel();
  int offset = 0;

  PostController();

  void updateTextPost(int index, String text) {
    posts[index].text = text;
    update(['description']);
  }

  Future<void> repost(int index, String? comment) async {
    ApiUtil.guardApiCall(() async {
      final post = posts[index];
      await Api.post(
        method: 'posts/${posts[index].id}/repost',
        body: {"repost_comment": comment},
        testMode: true,
        isAuth: true,
      );
    });
  }

  Future<void> addToFavorites(
    int index,
    Function(int e)? onError,
  ) async {
    ApiUtil.guardApiCall(() async {
      final post = posts[index];
      posts[index].isFavorites = !post.isFavorites;

      if (post.isFavorites) {
        await Api.post(
          method: 'posts/${posts[index].id}/favorite',
          body: {},
          testMode: true,
          isAuth: true,
        );
      } else {
        await Api.delete(
          method: 'posts/${posts[index].id}/favorite',
          testMode: true,
          isAuth: true,
        );
      }

      update(['like', 'svg-heart', 'likes-bar']);
    });
  }

  Future<void> switchPostLike(int index, Function(int e)? onError) async {
    try {
      if (posts[index].liked == 0) {
        posts[index].liked = 1;
        posts[index].likes!.count = posts[index].likes!.count! + 1;
        posts[index].likes!.users!.add(UserModel(
            id: SgUser.instance.user.id,
            nickname: SgUser.instance.user.nickname,
            avatar100: SgUser.instance.user.avatar100));
        update(['like', 'svg-heart', 'likes-bar']);
        // update(['likes-bar']);
        // update(['page-view']);
        //Posts.like(feed[index].id, token);
        await Api.post(
            method: 'posts/${posts[index].id}/like',
            body: {},
            testMode: true,
            isAuth: true);
      } else {
        posts[index].liked = 0;
        posts[index].likes!.count = posts[index].likes!.count! - 1;
        int i = 0;
        for (var like in posts[index].likes!.users!) {
          if (like.id == SgUser.instance.user.id) {
            posts[index].likes!.users!.removeAt(i);
            break;
          }
          i++;
        }
        update(['like', 'svg-heart', 'likes-bar']);
        // update(['like']);
        // update(['likes-bar']);
        // update(['page-view']);
        // Map mySelfData = await Posts.getSelfData(token);
        // for (var i in feed[index].likes?['users']) {
        //   if (i['nickname'] == mySelfData['nickname']) {
        //     feed[index].likes?['users'].remove(i);
        //     break;
        //   }
        // }
        // Posts.dislike(feed[index].id, token);
        await Api.delete(
            method: 'posts/${posts[index].id}/like',
            testMode: false,
            isAuth: true);
      }
      return;
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: Transition.cupertino);
          return;
        }
      }
      if (onError != null) {
        onError(e.code);
      }
      return;
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  //index = -1 если подписка идет чере профиль
  void follow(int index, Function(int e)? onError) async {
    try {
      print(user.toString());
      String userId = '';
      if (index == -1) {
        userId = user.id.toString();
        SgFollows.instance.follows.add(user.nickname!);
      } else {
        userId = posts[index].user!.id.toString();
        posts[index].canFollow = 0;
        SgFollows.instance.follows.add(posts[index].user!.nickname!);
        if (SgFollows.instance.unfollows
            .contains(posts[index].user!.nickname!)) {
          SgFollows.instance.unfollows.remove(posts[index].user!.nickname!);
        }
      }
      if (user.id != null) {
        user.canFollow = 0;
        user.followers = user.followers! + 1;
      }
      update(['follow']);
      await Api.post(
          method: 'users/$userId/follow',
          body: {},
          testMode: true,
          isAuth: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: Transition.cupertino);
          return;
        }
      }
      if (onError != null) {
        onError(e.code);
      }
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  void updateAllTags() {
    update(['like', 'svg-heart', 'likes-bar', 'follow', 'comments_count']);
  }

  void unfollow(int id, Function(int e)? onError) async {
    try {
      if (user.id != null) {
        user.canFollow = 1;
        user.followers = user.followers! - 1;
        SgFollows.instance.unfollows.add(user.nickname!);
        if (SgFollows.instance.follows.contains(user.nickname!)) {
          SgFollows.instance.follows.remove(user.nickname!);
        }
      }
      update(['follow']);
      await Api.delete(
          method: 'users/${user.id}/follow', testMode: true, isAuth: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: Transition.cupertino);
          return;
        }
      }
      if (onError != null) {
        onError(e.code);
      }
    } on StateError catch (e) {
      log('SKIP');
    }
  }
}
