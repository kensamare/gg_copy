import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_utils/api_util.dart';
import 'package:gg_copy/project_utils/controllers/rx_profile_reload.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import '../../login_screen/login_screen_provider.dart';
import 'st_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbProfileScreen extends Cubit<StProfileScreen> {
  CbProfileScreen() : super(StProfileScreenLoading());

  List<PostModel> posts = [];
  SelfModel user = SelfModel();
  bool _isReorderMode = false;

  Future<void> getData(String nickname, bool isSelf, int offset,
      {bool updateHeader = false}) async {
    try {
      Map<String, dynamic> self = await Api.get(
          method: 'users/${nickname}', testMode: false, isAuth: true);
      SelfModel user = SelfModel.fromJson(self["data"]);
      this.user = user;
      log(user.toString(), name: "LoadUser");
      if (updateHeader) {
        emit(StProfileScreenLoaded(
          user: this.user,
          posts: posts,
          isReorderingMode: _isReorderMode,
        ));
        return;
      }
      await getPost(offset);
    } on APIException catch (e) {
      emit(StProfileScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> getPost(int offset) async {
    try {
      Map<String, dynamic> response = await Api.get(
          method: 'posts',
          testMode: false,
          query: {"id_user": user.id, "limit": 15, "offset": offset},
          isAuth: true);

      response["data"].forEach((v) {
        posts.add(PostModel.fromJson(v));
      });

      emit(StProfileScreenLoaded(
        user: user,
        posts: posts,
        isReorderingMode: _isReorderMode,
      ));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StProfileScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> onReload(String nickname, bool isSelf, int offset) async {
    RxProfileReload profileReload = Get.find(tag: "reload");
    profileReload.addListener(() async {
      if (profileReload.isReload.value) {
        log("Зашло в перезагрузку ", name: "PROFILE");
        await getData(nickname, isSelf, offset);
        profileReload.setReload(false);
      }
    });
  }

  Future<bool> follow(String id) async {
    try {
      Map<String, dynamic> followData =
          await Api.post(method: "users/${id}/follow", body: {}, isAuth: true);
      log(followData.toString(), name: "FOLLOWDATA");
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
      emit(StProfileScreenError(error: e.code));
      return false;
    } on StateError catch (e) {
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
      emit(StProfileScreenError(error: e.code));
      return false;
    } on StateError catch (e) {
      log('SKIP');
      return false;
    }
  }

  Future<void> deleteSession() async {
    try {
      Map<String, dynamic> response = await Api.delete(
          method: 'sessions/current', isAuth: true, testMode: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
        }
      }
      emit(StProfileScreenError(error: e.code));
    } on StateError catch (e) {
      log("SKIP");
    }
  }

  Future<void> deletePost(
      int index, String nickname, bool isSelf, int offset) async {
    try {
      Map<String, dynamic> delete =
          await Api.delete(method: "posts/${posts[index].id}", isAuth: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StProfileScreenError(error: e.code));
      return;
    } on StateError catch (e) {
      log('SKIP');
      return;
    }
    if (posts.length - 1 == 0) {
      posts.removeAt(index);
      await getData(nickname, isSelf, offset, updateHeader: true);
    } else {
      posts.removeAt(index);
      emit(StProfileScreenLoaded(posts: posts, user: user));
    }
  }

  Future<void> unBloc() async {
    try {
      Map<String, dynamic> delete = await Api.delete(
          method: "users/${user.id}/block", isAuth: true, testMode: true);
      emit(StProfileScreenLoading());
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StProfileScreenError(error: e.code));
      return;
    } on StateError catch (e) {
      log('SKIP');
      return;
    }
  }

  void changePostOrderMode(bool isReorderMode) {
    if (!isReorderMode) {
      _updatePostsOrder();
    }

    _isReorderMode = isReorderMode;
    emit(StProfileScreenLoaded(
      posts: posts,
      user: user,
      isReorderingMode: isReorderMode,
    ));
  }

  Future<void> changeOrderOfImages({
    required int oldIndex,
    required int newIndex,
  }) async {
    /// Swapping user posts
    final temp = posts[oldIndex];
    posts.removeAt(oldIndex);
    posts.insert(newIndex, temp);

    /// Update UI
    emit(StProfileScreenLoaded(
      posts: posts,
      user: user,
      isReorderingMode: _isReorderMode,
    ));
  }

  Future<void> _updatePostsOrder() {
    List<String> queryList = [];

    for (int i = 0; i < posts.length; i++) {
      final key = 'post_sort[${posts[i].id!}]';
      queryList.add('$key=$i');
    }
    final queryParams = '?${queryList.join("&")}';

    return ApiUtil.guardApiCall(() async {
      await Api.put(
        method: 'users/self' + queryParams,
        body: {},
        isAuth: true,
        testMode: true,
      );
    });
  }
}
