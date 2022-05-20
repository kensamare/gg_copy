import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_type.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

import '../../../project_utils/controllers/rx_badges.dart';
import '../../../project_utils/pj_colors.dart';
import '../../../project_utils/pj_icons.dart';
import 'st_feed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbFeedScreen extends Cubit<StFeedScreen> {
  CbFeedScreen() : super(StFeedScreenLoading());

  List<PostModel> posts = [];
  int lastPostId = 0;

  Future<void> changeFeed() async {
    emit(StFeedScreenLoading());
  }

  Future<void> getPost(
      {bool goNext = false,
      bool subMode = false,
      bool isThirdFeed = false,
      bool subFavoriteMode = false}) async {
    RxBadges badgeController = Get.find(tag: 'badge');
    try {
      if (SgUser.instance.user.id == null) {
        Map<String, dynamic> self =
            await Api.get(method: 'users/self', testMode: false, isAuth: true);
        SgUser.instance.user = SelfModel.fromJson(self['data']);
      }
      Map<String, dynamic> query = {};
      if (goNext) {
        query = {'offset_post_id': lastPostId}; //posts.last.id!};
      }
      if (subMode) {
        badgeController.countPosts.value = 0;
        query['my'] = 1;
      }

      if (subFavoriteMode) {
        badgeController.countPosts.value = 0;
        query['my'] = 1;
        query['myfav'] = 1;
      }

      if (isThirdFeed) {
        query['hell'] = 1;
      }
      Map<String, dynamic> response =
          await Api.get(method: 'posts', isAuth: true, query: query);
      // List<PostModel> res = [];
      if (!goNext) {
        posts = [];
      }
      for (var post in response['data']) {
        posts.add(PostModel.fromJson(post));
      }
      lastPostId = response['last_post_id'].toInt();
      bool globalSelectMode = gSelect == PostTypeValue.my;
      if (globalSelectMode == subMode) emit(StFeedScreenLoaded(posts: posts));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StFeedScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> throwError(int code) async {
    emit(StFeedScreenError(error: code));
  }

  void deletePost(int index, {int? postId}) async {
    try {
      Map<String, dynamic> delete = await Api.delete(
          method: "posts/${postId ?? posts[index].id}", isAuth: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StFeedScreenError(error: e.code));
      return;
    } on StateError catch (e) {
      log('SKIP');
      return;
    }
    posts.removeAt(index);
    emit(StFeedScreenLoaded(posts: posts));
  }
}
