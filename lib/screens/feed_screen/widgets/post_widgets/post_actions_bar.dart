import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu_avatar.dart';
import 'package:gg_copy/project_utils/modals.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_widgets/success_sheet_content.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/cubit/cb_feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/repost_modal_content.dart';
import 'package:share_plus/share_plus.dart';

import '../../../comment_screen/comment_screen_provider.dart';

class PostActionsBar extends StatelessWidget {
  final int index;
  final bool comment;
  final String tag;
  final Function(int? postId)? deleteCallback;
  final bool profileFeed;

  late PostController _postController;

  PostActionsBar(
      {Key? key,
      required this.index,
      this.comment = false,
      required this.tag,
      this.deleteCallback,
      this.profileFeed = false})
      : super(key: key) {
    _postController = Get.find(tag: tag);
  }

  // final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
      init: _postController,
      id: 'like',
      global: false,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.0.w,
            vertical: 15.0.w,
          ),
          child: SizedBox(
            height: 20.w,
            child: Row(
              children: [
                SizedBox(
                  height: 20.0.w,
                  width: comment ? 61.3.w : 101.3.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          // padding: EdgeInsets.only(right: 5.w),
                          color: Colors.transparent,
                          child: Center(
                            child: SvgPicture.asset(
                              _.posts[index].liked ==
                                      0 //Добавить что-то нормальное
                                  ? PjIcons.heart
                                  : PjIcons.likedHeart,
                              height: 20.w,
                            ),
                          ),
                        ),
                        onTap: () {
                          _.switchPostLike(index, (e) {
                            BlocProvider.of<CbFeedScreen>(context)
                                .throwError(e);
                          });
                          // postsActionsController.switchPostLike(index);
                        },
                      ),
                      const Spacer(),
                      if (!comment) ...[
                        GestureDetector(
                          onTap: () async {
                            GetStorage().write('showComments', true);
                            var res = !profileFeed
                                ? await Get.toNamed(
                                    '/comment',
                                    arguments: index,
                                    id: SgNested.instance.id,
                                  )
                                : Get.to(CommentScreenProvider(
                                    index: index,
                                    tag: 'profileFeed',
                                    isBottomNavigation: false,
                                  ));
                            if (res is bool && deleteCallback != null) {
                              deleteCallback!(null);
                              return;
                            }
                            RxMenuAvatar cntrl = Get.find(tag: "menuAvatar");
                            cntrl.comment.value = false;
                          },
                          child: SvgPicture.asset(
                            PjIcons.comment,
                            height: 20.w,
                          ),
                        ),
                        SizedBox(width: 20.w),
                      ],
                      GestureDetector(
                        onTap: () {
                          showGGBottomSheet(
                              context,
                              (_) {
                                return RepostModalContent(
                                    onRepostPress: (context, comment) async {
                                  _postController.repost(index, comment);
                                  Navigator.pop(context);
                                  Get.bottomSheet(SuccessSheetContent(
                                      text:
                                          "Вы поделились этой публикацией с подписчиками."));
                                });
                              },
                              "Поделиться в ленте",
                              (context) {
                                return IconButton(
                                    onPressed: () {
                                      String shareLink =
                                          'https://grustnogram.ru/p/${_postController.posts[index].url}';
                                      Share.share(shareLink);
                                    },
                                    iconSize: 18.w,
                                    icon: SvgPicture.asset(
                                      PjIcons.share2,
                                      height: 18.w,
                                    ));
                              },
                              (context) {
                                return IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    iconSize: 18.w,
                                    icon: SvgPicture.asset(
                                      PjIcons.decline,
                                      height: 18.w,
                                    ));
                              });
                        },
                        behavior: HitTestBehavior.translucent,
                        child: SvgPicture.asset(
                          PjIcons.share,
                          height: 20.w,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    _.addToFavorites(
                      index,
                      (e) => context.read<CbFeedScreen>().throwError(e),
                    );
                  },
                  child: SvgPicture.asset(
                    _.posts[index].isFavorites
                        ? PjIcons.bookmarkFilled
                        : PjIcons.bookmark,
                    height: 24.w,
                    width: 24.w,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
