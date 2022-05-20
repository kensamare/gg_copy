import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/models/comment_replies_model.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';

import '../../../models/comment_data_model.dart';
import '../../feed_screen/controllers/post_controller.dart';
import '../../login_screen/login_screen_provider.dart';
import 'st_comment_from_notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbCommentFromNotificationsScreen extends Cubit<StCommentFromNotificationsScreen> {
  CbCommentFromNotificationsScreen() : super(StCommentFromNotificationsScreenLoading());
  List<CommentDataModel> comments = [];
  List<PostModel> postModel = [];

  Future<void> getComment(String url) async {
    try {
      Map<String, dynamic> response = await Api.get(method: 'p/$url', isAuth: true, testMode: true);
      postModel.add(PostModel.fromJson(response['data']));
      Map<String, dynamic> responseHelp = response['data'];
      Map<String, dynamic> responseHelping = responseHelp['comments'];
      for (var data in responseHelping['data']) {
        comments.add(CommentDataModel.fromJson(data));
      }
      emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentFromNotificationsScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  Future<void> sendComment(int id, String comment, int index) async {
    try {
      Map<String, dynamic> response = await Api.post(
          method: 'posts/$id/comments',
          testMode: false,
          isAuth: true,
          body: {
            "comment": comment,
            "reply_to": SgComments.instance.getIdReply == -1 ? 0 : SgComments.instance.getIdReply,
          });
      log(SgComments.instance.getIdReply.toString());
      if (SgComments.instance.getIdReply == -1) {
        comments.add(CommentDataModel.fromJson(response['data']));
        comments[comments.length - 1].liked = 0;
        comments[comments.length - 1].avatar = SgUser.instance.user.avatar;
        comments[comments.length - 1].repliesCount = 0;
        comments[comments.length - 1].replies = [];
        postModel[0].comments!.count = postModel[0].comments!.count! + 1;
        // PostController c = Get.find(tag: 'myControllerForPosts');
        // c.posts[0].comments!.count =
        //     c.posts[0].comments!.count! + 1;
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

      emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(),
              transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentFromNotificationsScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }

    // try {
    //   Map<String, dynamic> response =
    //       await Api.post(method: 'posts/$id/comments', testMode: true, isAuth: true, body: {"comment": comment});
    //   comments.add(CommentDataModel.fromJson(response['data']));
    //   comments[comments.length - 1].liked = 0;
    //   PostController c = Get.find(tag: 'myControllerForPosts');
    //   c.posts[index].comments!.count = c.posts[index].comments!.count! + 1;
    //   emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
    // } on APIException catch (e) {
    //   if (e.code == 400) {
    //     Map<String, dynamic> error = jsonDecode(e.body);
    //     if (error['err'][0] == 4 || error['err'][0] == 5) {
    //       Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
    //       return;
    //     }
    //   }
    //   emit(StCommentFromNotificationsScreenError(error: e.code));
    // } on StateError catch (e) {
    //   log('SKIP');
    // }
  }

  Future<void> getNewComments(int id, int offset) async {
    try {
      Map<String, dynamic> response =
          await Api.get(method: 'posts/${id}/comments', testMode: true, isAuth: true, query: {"offset": offset});
      for (var data in response['data']) {
        comments.add(CommentDataModel.fromJson(data));
      }
      emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentFromNotificationsScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }

  void deletePost(int index, int init) async {
    try {
      Map<String, dynamic> delete = await Api.delete(method: "posts/${postModel[index].id}", isAuth: true);
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentFromNotificationsScreenError(error: e.code));
      return;
    } on StateError catch (e) {
      log('SKIP');
      return;
    }

    navigateToNav(initIndex: init);
    // posts.removeAt(index);
    // emit(StFeedScreenLoaded(posts: posts));
  }

  Future<void> deleteComment(int commentId, int index, int postIndex, bool isReplyDelete) async {
    Get.back();
    Api.delete(
        method: 'posts/comments/${commentId}', testMode: false, isAuth: true);
    PostController c = Get.find(tag: 'myControllerForPosts');
    if (!isReplyDelete) {
      postModel[0].comments!.count = postModel[0].comments!.count! - 1;
      // c.posts[postIndex].comments!.count =
      //     c.posts[postIndex].comments!.count! - 1;
      comments.removeAt(index);
    } else {
      comments[SgComments.instance.getIndexReply].replies!.removeAt(index);
      comments[SgComments.instance.getIndexReply].repliesCount =
          comments[SgComments.instance.getIndexReply].repliesCount! - 1;
    }
    emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
  }

  Future<void> getRepliesComments(int idComment, int id, int lastCommentId, int commentIndex) async {
    try {
      Map<String, dynamic> response =
          await Api.get(method: 'posts/$id/commentsreply/$idComment', testMode: false, isAuth: true, query: {
        "limit": 3,
        "last_comment_id": lastCommentId,
      });
      for (var data in response['data']) {
        comments[commentIndex].replies!.add(CommentRepliesModel.fromJson(data));
      }

      emit(StCommentFromNotificationsScreenLoaded(comments: comments, postModel: postModel));
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StCommentFromNotificationsScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
  }
}
