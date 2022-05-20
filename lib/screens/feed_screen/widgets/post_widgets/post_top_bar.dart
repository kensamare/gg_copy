import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/bloc_getx/controllers/posts_actions_conttroller.dart';
import 'package:gg_copy/models/user_model.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_follows.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/cubit/cb_feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/cubit/st_feed_screen.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/cubit/st_posts.dart';
import 'option_bottom_sheet.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class PostTopBar extends StatefulWidget {
  final UserModel user;
  final int index;
  final String tag;
  final bool deleteWithBack;
  final Function(int postId)? deleteCallback;
  final bool nestedNav;
  final Function()? editPostDone;
  final bool showDots;

  const PostTopBar(
      {Key? key,
      required this.user,
      required this.index,
      required this.deleteWithBack,
      required this.tag,
      required this.nestedNav,
      this.deleteCallback,
      required this.editPostDone,
      this.showDots = true})
      : super(key: key);

  @override
  State<PostTopBar> createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  late PostController _postController;
  bool isBlock = false;

  @override
  void initState() {
    _postController = Get.find(tag: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Не должно существовать!!!
    // GetStorage().listenKey('isBlock', (value) async {
    //   isBlock = value;
    //   if (isBlock == true) {
    //     Get.bottomSheet(
    //       Container(
    //         height: 200.w,
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).hintColor,
    //           borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 18.0.w,
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Column(
    //                 children: [
    //                   SizedBox(
    //                     height: 26.w,
    //                   ),
    //                   SvgPicture.asset(
    //                     PjIcons.appleid,
    //                     width: 44.w,
    //                     height: 44.w,
    //                   ),
    //                   SizedBox(
    //                     height: 26.w,
    //                   ),
    //                   SizedBox(
    //                     width: 224.w,
    //                     child: Text(
    //                       'Пользователь ${widget.user.nickname} заблокирован',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyles.interMedium16_808080,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //     await Future.delayed(const Duration(seconds: 1), () {
    //       Get.back();
    //     });
    //     GetStorage().write('isBlock', false);
    //   }
    // });
    // log(widget.user.toString(), name: "user");
    return SizedBox(
      height: 28.w,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                CircleAvatar(
                    radius: 14.w,
                    backgroundImage: CachedNetworkImageProvider(widget.user
                        .avatar100!) //NetworkImage(widget.user.avatar100!),
                    ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  widget.user.nickname!.length > 13
                      ? (widget.user.nickname!.substring(0, 13) + '...')
                      : widget.user.nickname!,
                  style: TextStyles.interMedium14,
                ),
              ],
            ),
            onTap: () {
              log(
                  (SgUser.instance.user.nickname == widget.user.nickname!)
                      .toString(),
                  name: 'QWERT');
              if (SgUser.instance.user.nickname == widget.user.nickname!) {
                navigateToNav(initIndex: 4);
                // Get.offAll(() => NavigationScreen(
                //   init: 4,
                // ));
                return;
              }
              Get.to(
                      () => ProfileScreenProvider(
                          nickname: widget.user.nickname!),
                      transition: tr.Transition.cupertino)
                  ?.then((value) => _postController.updateAllTags());
              // Get.toNamed('/comment', arguments: widget.user.nickname, id: 1);
            },
          ),
          SizedBox(
            width: 12.0.w,
          ),
          GetBuilder<PostController>(
            init: _postController,
            id: 'follow',
            global: false,
            builder: (_) {
              Widget follow = SizedBox(
                width: 104.w,
                height: 28.w,
                child: CupertinoButton(
                  color: Theme.of(context).canvasColor,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(5),
                  child: Text(
                    'Подписаться',
                    style: TextStyles.interRegular12,
                  ),
                  onPressed: () {
                    _.follow(widget.index, (e) {
                      BlocProvider.of<CbFeedScreen>(context).throwError(e);
                    });
                  },
                ),
              );
              if (SgFollows.instance.follows
                  .contains(_.posts[widget.index].user!.nickname!)) {
                return SizedBox();
              } else if (SgFollows.instance.unfollows
                  .contains(_.posts[widget.index].user!.nickname!)) {
                return follow;
              }
              if (_postController.posts[widget.index].canFollow == 0) {
                return SizedBox();
              } else {
                return follow;
              }
            },
          ),
          const Spacer(),
          if (widget.showDots)
            GestureDetector(
              onTap: () async {
                var res = await Get.bottomSheet(OptionBottomSheet(
                  idEditPost: widget.index,
                  tag: widget.tag,
                  timeCreated: (_postController.posts[widget.index].createdAt!),
                  postId: _postController.posts[widget.index].id!,
                  url: _postController.posts[widget.index].url!,
                  userId: widget.user.id!,
                  userNickname: widget.user.nickname!,
                  deleteWithBack: widget.deleteWithBack,
                  canDelete: _postController.posts[widget.index].canDelete ?? 0,
                ));
                if (widget.deleteWithBack && res is bool) {
                  if (widget.nestedNav) {
                    Get.back(result: true, id: SgNested.instance.id);
                  } else {
                    Get.back(result: true);
                  }
                }
                if (res is bool &&
                    widget.deleteCallback != null &&
                    !widget.deleteWithBack) {
                  widget
                      .deleteCallback!(_postController.posts[widget.index].id!);
                }
              },
              child: SvgPicture.asset(
                PjIcons.dotsMenu,
                width: 32.0.w,
              ),
            ),
        ],
      ),
    );
  }
}
