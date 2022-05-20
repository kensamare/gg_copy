import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/models/post_model.dart';

import '../../../models/self_model.dart';
import '../../login_screen/login_screen_provider.dart';
import 'st_search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbSearchScreen extends Cubit<StSearchScreen> {
  CbSearchScreen() : super(StSearchScreenLoading());

  Future<void> getData(String query) async {
    emit(StSearchScreenLoading());
    List<SelfModel> users = [];
    List<PostModel> posts = [];

    final encodedQuery = Uri.encodeComponent(query);

    try {
      Map<String, dynamic> response = await Api.get(method: 'users', testMode: true, isAuth: true, query: {"q": encodedQuery});
      for (var data in response['data']) {
        users.add(SelfModel.fromJson(data));
      }
      Map<String, dynamic> responsePost =
          await Api.get(method: 'posts', testMode: true, isAuth: true, query: {"q": encodedQuery});
      for (var data in responsePost['data']) {
        posts.add(PostModel.fromJson(data));
      }
      emit(StSearchScreenLoaded(users: users, posts: posts));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StSearchScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> getTopData() async {
    emit(StSearchScreenLoading());
    List<SelfModel> users = [];
    List<PostModel> posts = [];
    try {
      Map<String, dynamic> response =
          await Api.get(method: 'users', testMode: true, isAuth: true, query: {"q": '', "top": 1});
      for (var data in response['data']) {
        users.add(SelfModel.fromJson(data));
      }
      Map<String, dynamic> responsePost =
          await Api.get(method: 'posts', testMode: true, isAuth: true, query: {"top": 1});
      for (var data in responsePost['data']) {
        posts.add(PostModel.fromJson(data));
      }
      emit(StSearchScreenInit(users: users, posts: posts));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StSearchScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }
}
