import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/favorites_screen/cubit/st_favorites_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

import '../../../project_utils/api_util.dart';

class CbFavoritesScreen extends Cubit<StFavoritesScreen> {
  CbFavoritesScreen() : super(StFavoritesScreenLoading()) {
    getPost();
  }

  List<PostModel> _posts = [];
  int _lastPostId = 0;

  Future<void> changeFeed() async {
    emit(StFavoritesScreenLoading());
  }

  Future<void> getPost({
    bool goNext = false,
  }) async {
    ApiUtil.guardApiCall(
      () async {
        if (SgUser.instance.user.id == null) {
          Map<String, dynamic> self = await Api.get(
              method: 'users/self', testMode: false, isAuth: true);
          SgUser.instance.user = SelfModel.fromJson(self['data']);
        }

        Map<String, dynamic> query = {'fav': 1};
        if (goNext) {
          query['offset_post_id'] = _lastPostId;
        }

        Map<String, dynamic> response =
            await Api.get(method: 'posts', isAuth: true, query: query);

        if (!goNext) {
          _posts = [];
        }
        for (var post in response['data']) {
          _posts.add(PostModel.fromJson(post));
        }

        _lastPostId = response['last_post_id'].toInt();
        emit(StFavoritesScreenLoaded(posts: _posts));
      },
      onError: (errorCode) {
        emit(StFavoritesScreenError(error: errorCode));
      },
    );
  }

  void deletePost(int index) async {
    ApiUtil.guardApiCall(
      () async {
        await Api.delete(
          method: "posts/${_posts[index].id}",
          isAuth: true,
        );
        _posts.removeAt(index);
        emit(StFavoritesScreenLoaded(posts: _posts));
      },
      onError: (int errorCode) {
        emit(StFavoritesScreenError(error: errorCode));
      },
    );
  }

  Future<void> throwError(int code) async {
    emit(StFavoritesScreenError(error: code));
  }
}
