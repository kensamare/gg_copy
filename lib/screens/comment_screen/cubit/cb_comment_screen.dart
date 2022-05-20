import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/models/comment_data_model.dart';
import 'package:gg_copy/models/comment_replies_model.dart';
import 'package:gg_copy/models/comments_model.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

import 'st_comment_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbCommentScreen extends Cubit<StCommentScreen> {
  CbCommentScreen({required this.tag}) : super(StCommentScreenLoading());

  List<CommentDataModel> comments = [];
  final String tag;

  Future<void> getComment(int id, int offset) async {
    try {
      Map<String, dynamic> response = await Api.get(
        method: 'posts/${id}/comments',
        testMode: true,
        isAuth: true,
        query: {"offset": offset},
      );
      for (var data in response['data']) {
        comments.add(CommentDataModel.fromJson(data));
      }
      emit(StCommentScreenLoaded(comments: comments));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> sendComment(
      int id, String comment, int index, int postIndex) async {
    try {
      Map<String, dynamic> response = await Api.post(
          method: 'posts/$id/comments',
          testMode: false,
          isAuth: true,
          body: {
            "comment": comment,
            "reply_to": SgComments.instance.getIdReply == -1 ? 0 : SgComments.instance.getIdReply,
          });
      if (SgComments.instance.getIdReply == -1) {
        comments.add(CommentDataModel.fromJson(response['data']));
        comments[comments.length - 1].liked = 0;
        comments[comments.length - 1].avatar = SgUser.instance.user.avatar;
        comments[comments.length - 1].repliesCount = 0;
        comments[comments.length - 1].replies = [];
        PostController c = Get.find(tag: tag);
        c.posts[postIndex].comments!.count =
            c.posts[postIndex].comments!.count! + 1;
      } else {
        comments[SgComments.instance.getIndexReply].repliesCount =
            comments[SgComments.instance.getIndexReply].repliesCount! + 1;
        comments[SgComments.instance.getIndexReply]
            .replies!
            .add(CommentRepliesModel.fromJson(response['data']));
        comments[SgComments.instance.getIndexReply]
            .replies![
                comments[SgComments.instance.getIndexReply].replies!.length - 1]
            .liked = 0;
        comments[SgComments.instance.getIndexReply]
            .replies![
                comments[SgComments.instance.getIndexReply].replies!.length - 1]
            .avatar = SgUser.instance.user.avatar;
      }
      SgComments.instance.setIdReply = -1;
      //GetStorage().write('idReply', null);

      emit(StCommentScreenLoaded(comments: comments));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> deleteComment(
      int commentId, int index, int postIndex, bool isReplyDelete) async {
    Get.back();
    Api.delete(
        method: 'posts/comments/${commentId}', testMode: false, isAuth: true);
    PostController c = Get.find(tag: tag);
    if (!isReplyDelete) {
      c.posts[postIndex].comments!.count =
          c.posts[postIndex].comments!.count! - 1;
      comments.removeAt(index);
    } else {
      comments[SgComments.instance.getIndexReply].replies!.removeAt(index);
      comments[SgComments.instance.getIndexReply].repliesCount =
          comments[SgComments.instance.getIndexReply].repliesCount! - 1;
    }
    emit(StCommentScreenLoaded(comments: comments));
  }

  Future<void> getRepliesComments(
      int idComment, int id, int lastCommentId, int commentIndex) async {
    try {
      Map<String, dynamic> response = await Api.get(
          method: 'posts/$id/commentsreply/$idComment',
          testMode: false,
          isAuth: true,
          query: {
            "limit": 3,
            "last_comment_id": lastCommentId,
          });
      for (var data in response['data']) {
        comments[commentIndex].replies!.add(CommentRepliesModel.fromJson(data));
      }

      emit(StCommentScreenLoaded(comments: comments));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }
}
