import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_user_id.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen_provider.dart';
import 'package:gg_copy/screens/comment_screen/comment_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/report_bottom_sheet.dart';
import 'package:gg_copy/screens/posts_page_builder_screen/posts_page_builder_screen.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_feed_screen.dart';
import 'package:intl/intl.dart';
import 'package:gg_copy/screens/share_screen/share_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import '../../../edit_comment_screen/edit_comment_screen.dart';
import '../../../edit_comment_screen/edit_comment_screen_provider.dart';
import '../../../login_screen/login_screen_provider.dart';
import '../../../profile_screen/cubit/cb_profile_screen.dart';
import '../../controllers/post_controller.dart';

class OptionBottomSheet extends StatelessWidget {
  final int? timeCreated;
  final int? idEditPost;
  final String? tag;
  final int postId;
  final String url;
  final int userId;
  final bool deleteWithBack;
  final bool isNotSelf;
  final String userNickname;
  final int canDelete;
  final bool isRepost;
  final int? index;
  final PostController? postController;

  OptionBottomSheet({
    this.idEditPost,
    this.tag,
    this.timeCreated,
    required this.postId,
    this.isNotSelf = false,
    this.isRepost = false,
    required this.url,
    required this.userId,
    required this.userNickname,
    required this.deleteWithBack,
    this.index,
    this.canDelete = 0,
    this.postController,
    Key? key,
  }) : super(key: key);

  RxUserId userIdController = Get.find(tag: 'userId');
  dynamic isEditDone = false;

  int localUserId = 0;

  @override
  Widget build(BuildContext context) {
    userIdController.userId.value = userId;
    log(postId.toString(), name: "IDDDDDPOSTTTTTTTT");
    log(userId.toString(), name: "userIdddd");
    log(userIdController.userId.value.toString(), name: "userIdddd2");
    log(SgUser.instance.user.id.toString(), name: "SgUserId");
    //log('${((DateTime.now().millisecondsSinceEpoch ~/ 1000) - timeCreated!) ~/ 60}', name: 'TIMEEEEE');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.w,
            ),
            if (SgUser.instance.user.id == userId &&
                ((DateTime.now().millisecondsSinceEpoch ~/ 1000) -
                            timeCreated!) ~/
                        60 <=
                    30) ...[
              if (isRepost == false)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: Theme.of(context).canvasColor,
                  child: Center(
                    child: Text(
                      'редактировать пост',
                      style: TextStyles.interMedium14,
                    ),
                  ),
                  onPressed: () async {
                    isEditDone = await Get.to(
                      () => EditCommentScreenProvider(
                        idPost: postId,
                        tag: tag!,
                        idEditPost: idEditPost!,
                      ),
                    );
                    if (isEditDone == true) {
                      Get.back(result: 'post_edited');
                    }
                  },
                ),
              SizedBox(
                height: 10.w,
              ),
            ],
            if (isRepost)
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: Text(
                    'перейти к записи',
                    style: TextStyles.interMedium14,
                  ),
                ),
                onPressed: () {
                  print(index);
                  print(tag);
                  Get.to(() => CommentFromNotificationsScreenProvider(
                        index: 0,
                        url: postController!.posts[index!].url!,
                        notification: false,
                      ));
                },
              ),
            if (isRepost == false)
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: Text(
                    'поделиться',
                    style: TextStyles.interMedium14,
                  ),
                ),
                onPressed: () {
                  if (isNotSelf) {
                    Get.to(
                        () => ShareScreen(
                              nickname: userNickname,
                            ),
                        transition: tr.Transition.cupertino);
                  } else {
                    String shareLink = 'https://grustnogram.ru/p/$url';
                    Share.share(shareLink);
                    Get.back();
                  }
                },
              ),
            SizedBox(
              height: 10.w,
            ),
            SgUser.instance.user.id != userIdController.userId.value
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Theme.of(context).canvasColor,
                    child: Center(
                      child: Text(
                        'пожаловаться',
                        style: isNotSelf
                            ? TextStyles.interMedium14
                            : TextStyles.interMedium14Red,
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      // Navigator.pop(context);
                      Get.bottomSheet(ReportBottomSheet(
                        postId: postId,
                        nickname: SgUser.instance.user.id != userId
                            ? null
                            : SgUser.instance.user.nickname,
                        blockUser: isNotSelf,
                        userId: userIdController.userId.value,
                      ));
                      // showModalBottomSheet(
                      //   backgroundColor: Colors.transparent,
                      //   context: context,
                      //   builder: (context) {
                      //     return ReportBottomSheet(postId: postId,);
                      //   },
                      // );
                    },
                  )
                : Container(),
            SizedBox(
              height: SgUser.instance.user.id != userIdController.userId.value
                  ? 10.w
                  : 0.w,
            ),
            if (SgUser.instance.user.id == userIdController.userId.value ||
                canDelete == 1) ...[
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: Text(
                    'удалить пост',
                    style: TextStyles.interMedium14Red,
                  ),
                ),
                onPressed: () async {
                  // try {
                  //   Map<String, dynamic> response = await Api.delete(method: 'posts/$postId', isAuth: true);
                  //   GetStorage().write('isBlock', true);
                  // } on APIException catch(e) {
                  //   if(e.code == 400){
                  //     Map<String, dynamic> error = jsonDecode(e.body);
                  //     if(error['err'][0] == 4 || error['err'][0] == 5){
                  //       Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
                  //       return;
                  //     }
                  //   }
                  // }
                  Get.back(result: true);
                },
              ),
              SizedBox(
                height: 10.w,
              ),
            ] else
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: Text(
                    'заблокировать $userNickname',
                    style: TextStyles.interMedium14Red,
                  ),
                ),
                onPressed: () async {
                  log(userIdController.userId.value.toString(), name: "userID");
                  try {
                    Map<String, dynamic> response = await Api.post(
                        method:
                            'users/${isNotSelf ? userIdController.userId.value : userId}/block',
                        isAuth: true,
                        body: {});
                    Get.back();
                    Get.bottomSheet(
                      Container(
                        height: 200.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.w),
                              topRight: Radius.circular(12.w)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.0.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 26.w,
                                  ),
                                  SvgPicture.asset(
                                    PjIcons.appleid,
                                    width: 44.w,
                                    height: 44.w,
                                  ),
                                  SizedBox(
                                    height: 26.w,
                                  ),
                                  SizedBox(
                                    width: 224.w,
                                    child: Text(
                                      'Пользователь $userNickname заблокирован',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.interMedium16_808080,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 1), () {
                      Get.back();
                    });
                  } on APIException catch (e) {
                    if (e.code == 400) {
                      Map<String, dynamic> error = jsonDecode(e.body);
                      if (error['err'][0] == 4 || error['err'][0] == 5) {
                        Get.offAll(LoginScreenProvider(),
                            transition: tr.Transition.cupertino);
                        return;
                      }
                    }
                  } on StateError catch (e) {
                    log('SKIP');
                  }
                  Get.back();
                },
              ),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
