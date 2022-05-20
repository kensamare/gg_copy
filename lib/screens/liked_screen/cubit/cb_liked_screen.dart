import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:gg_copy/models/comment_data_model.dart';
import 'package:gg_copy/models/comments_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/liked_screen/cubit/st_liked_screen.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbLikedScreen extends Cubit<StLikedScreen> {
  CbLikedScreen() : super(StLikedScreenLoading());

  List<SelfModel> users = [];

  Future<void> getLiked(int id, int offset) async {
    try {
      Map<String, dynamic> response = await Api.get(
          method: 'posts/${id}/likes',
          testMode: false,
          isAuth: true,
          query: {"offset": offset});
      for(var data in response['data']){
        users.add(SelfModel.fromJson(data));
      }
      emit(StLikedScreenLoaded(users: users));
    } on APIException catch (e) {
      if(e.code == 400){
        Map<String, dynamic> error = jsonDecode(e.body);
        if(error['err'][0] == 4 || error['err'][0] == 5){
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StLikedScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }

  Future<bool> follow(String id) async {
    try {
      Map<String, dynamic> followData =
      await Api.post(method: "users/${id}/follow", body: {}, isAuth: true, testMode: false);
      if (followData['err'].first == 0) {
        return true;
      } else {
        return false;
      }
    } on APIException catch (e) {
      emit(StLikedScreenError(error: e.code));
      return false;
    } on StateError catch(e){
      log('SKIP');
      return false;
    }
  }

  Future<bool> unfollow(String id) async {
    try {
      Map<String, dynamic> followData =
      await Api.delete(method: "users/${id}/follow", isAuth: true);
      if (followData['err'].first == 0) {
        return true;
      } else {
        return false;
      }
    } on APIException catch (e) {
      emit(StLikedScreenError(error: e.code));
      return false;
    } on StateError catch(e){
      log('SKIP');
      return false;
    }
  }
}
