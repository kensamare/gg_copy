import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/models/user_model.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';

import 'st_self_feed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbSelfFeedScreen extends Cubit<StSelfFeedScreen> {
  CbSelfFeedScreen(List<PostModel> post) : super(StSelfFeedScreenLoaded(posts: post)){
    posts = post;
  }

  int lastPostId = 0;
  List<PostModel> posts = [];
  SelfModel user = SelfModel();

  Future<void> getPost({bool goNext = false}) async {
    try {
      Map<String, dynamic> query = {};
      if (goNext) {
        query = {'offset_post_id': lastPostId};
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
      emit(StSelfFeedScreenLoaded(posts: posts));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StSelfFeedScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }
}
