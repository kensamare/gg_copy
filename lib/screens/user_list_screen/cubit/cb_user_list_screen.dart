import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_profile_reload.dart';

import '../../login_screen/login_screen_provider.dart';
import 'st_user_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbUserListScreen extends Cubit<StUserListScreen> {
  CbUserListScreen() : super(StUserListScreenLoading());

  Future<void> getData(String request) async {
    try {
      List<SelfModel> users = [];
      Map<String, dynamic> response = await Api.get(
        method: request,
        testMode: false,
        isAuth: true,
      );
      if (response["err"][0] == 0) {
        response["data"].forEach((v) {
          users.add(SelfModel.fromJson(v));
        });
        log(users.length.toString(), name: "USERSLIST");
        emit(StUserListScreenLoaded(users: users));
      } else {
        StUserListScreenError(error: response["err"]);
      }
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StUserListScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }

  Future<bool> follow(String id) async {
    try {
      Map<String, dynamic> followData = await Api.post(
          method: "users/${id}/follow",
          body: {},
          isAuth: true,
          testMode: false);
      log(followData.toString(), name: "FOLLOWDATA");
      if (followData['err'].first == 0) {
        log("ПОДПИСКА ОФОТРМЕНА УСПЕШНО");
        return true;
      } else {
        return false;
      }
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return false;
        }
      }
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
      log(followData.toString(), name: "UNFOLLOWDATA");
      if (followData['err'].first == 0) {
        return true;
      } else {
        return false;
      }
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return false;
        }
      }
      return false;
    } on StateError catch(e){
      log('SKIP');
      return false;
    }
  }

  Future<void> favorite(String id) async {
    try {
      Map<String, dynamic> followData =
          await Api.post(method: "users/${id}/favorite", isAuth: true, body: {}, testMode: false);
      log(followData.toString(), name: "FAVORITEDATA");
      if (followData['err'].first != 0) {
        emit(StUserListScreenError(error: followData['err'].first));
      } 
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StUserListScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
      return;
    }
  }

  Future<void> unfavorite(String id) async {
    try {
      Map<String, dynamic> followData =
          await Api.delete(method: "users/${id}/favorite", isAuth: true);
      log(followData.toString(), name: "UNFAVORITEDATA");
      if (followData['err'].first != 0) {
        emit(StUserListScreenError(error: followData['err'].first));
      }
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StUserListScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
      return;
    }
  }

  void onReload(String request) {
    //@todo Тут говно
    RxProfileReload reloadProfile = Get.find(tag: "reload");
    reloadProfile.addListener(() async {
      if (reloadProfile.isReload.value) {
        //await getData(request);
        reloadProfile.setReload(false);
      }
    });
  }
}
