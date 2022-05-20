import 'dart:developer';

import '../../../../../models/post_model.dart';
import 'st_posts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbPosts extends Cubit<StPosts> {
  CbPosts() : super(StPostsLoading());

  List<PostModel> posts = [];

  Future<void> getData(String id, int offset) async {
    try {

      Map<String, dynamic> response = await Api.get(
          method: 'posts',
          testMode: true,
          query: {"id_user": id, "limit": 12, "offset": offset},
          isAuth: true);

      response["data"].forEach((v) {
        posts.add(PostModel.fromJson(v));
      });

      emit(StPostsLoaded(posts: posts));
    } on APIException catch (e) {
      emit(StPostsError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }
}
