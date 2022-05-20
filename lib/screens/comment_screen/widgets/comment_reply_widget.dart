import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/models/comment_replies_model.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/parsed_text/flutter_parsed_text.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/cubit/cb_comment_from_notifications_screen.dart';
import 'package:gg_copy/screens/comment_screen/cubit/cb_comment_screen.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/report_bottom_sheet.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/screens/search_screen/search_screen_provider.dart';

import '../../../project_utils/time_conventer.dart';
import '../../profile_screen/profile_screen_provider.dart';

class CommentReplyWidget extends StatefulWidget {
  final CommentRepliesModel data;
  final int indexReply;
  final int index;
  final int postIndex;
  final Function()? deleteCallback;
  final bool isFromNotifications;
  final int offset;
  final Function(int, int)? getNewComments;
  final Function()? replyCallback;

  const CommentReplyWidget(
      {required this.data,
      required this.indexReply,
      required this.index,
      required this.postIndex,
      this.replyCallback,
      Key? key,
      this.deleteCallback,
      this.isFromNotifications = false,
      this.getNewComments,
      this.offset = 0})
      : super(key: key);

  @override
  State<CommentReplyWidget> createState() => _CommentReplyWidgetState();
}

class _CommentReplyWidgetState extends State<CommentReplyWidget> {
  late Key kakoytoBlyadskiKluch;
  late PostController _postController;

  @override
  void initState() {
    widget.isFromNotifications
        ? _postController = Get.find(tag: 'myControllerForPosts')
        : null;
    kakoytoBlyadskiKluch = UniqueKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.data.canDelete ??= 1;

    widget.data.likes ??= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                String nickname = widget.data.nickname!;
                  if (SgUser.instance.user.nickname == nickname.replaceAll("@", "")) {
                    navigateToNav(initIndex: 4);
                    return;
                  }
                  Get.to(() => ProfileScreenProvider(nickname: nickname.replaceAll("@", "").replaceAll("\n", "")),
                      transition: tr.Transition.cupertino)
                      ?.then((value) {
                    {
                      _postController.updateAllTags();
                    }
                  });
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(widget.data.avatar!),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${widget.data.nickname}',
                    style: TextStyles.interSemiBold14,
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  ReportBottomSheet(
                      nickname: SgUser.instance.user.nickname ==
                          widget.data.nickname
                          ? widget.data.nickname
                          : null,
                      commentId: widget.data.id,
                      callback: () async {
                        SgComments.instance.setIndexReply = widget.index;
                        //GetStorage().write('indexReply', widget.index);
                        widget.isFromNotifications
                            ? await BlocProvider.of<CbCommentFromNotificationsScreen>(
                            context)
                            .deleteComment(
                            widget.data.id!,
                            widget.indexReply,
                            0,
                            true)
                            : await BlocProvider.of<CbCommentScreen>(
                            context)
                            .deleteComment(
                            widget.data.id!,
                            widget.indexReply,
                            widget.postIndex,
                            true);
                      },
                      canDelete: widget.data.canDelete),
                );
              },
              child: SvgPicture.asset(
                PjIcons.dotsMenu,
                width: 32.0.w,
                color: PjColors.grey3,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.w),

        ParsedText(
          text: widget.data.comment!,
          nickName: '',
          style: TextStyles.interRegular14o70,
          onBack: () {
            _postController.updateAllTags();
          },
          showFull: true,
          parse: [
            for (String link in widget.data.links!)
              MatchText(
                  pattern: link,
                  style: TextStyles.interSemiBold14,
                  onTap: (nickname) {
                    if (SgUser.instance.user.nickname == link.replaceAll("@", "")) {
                      navigateToNav(initIndex: 4);
                      return;
                    }
                    Get.to(() => ProfileScreenProvider(nickname: link.replaceAll("@", "").replaceAll("\n", "")),
                        transition: tr.Transition.cupertino)
                        ?.then((value) {
                      {
                        _postController.updateAllTags();
                      }
                    });
                  }),
            MatchText(
                pattern: r'\B#+([^\x00-\x7F]|\w)+',
                style: TextStyles.interSemiBold14,
                onTap: (value) {
                  Get.to(
                          () => SearchScreenProvider(
                        search: value,
                      ),
                      transition: tr.Transition.cupertino)
                      ?.then((value) {
                    {
                      _postController.updateAllTags();
                    }
                  });
                }),
          ],
        ),

        // RichText(
        //   text: TextSpan(
        //     recognizer: TapGestureRecognizer()
        //       ..onTap = () {
        //         if (SgUser.instance.user.nickname == widget.data.nickname!) {
        //           navigateToNav(initIndex: 4);
        //           // Get.offAll(() => NavigationScreen(
        //           //       init: 4,
        //           //     ));
        //           return;
        //         }
        //         Get.to(
        //             () => ProfileScreenProvider(
        //                 nickname: widget.data.nickname!),
        //             transition: tr.Transition.cupertino);
        //         // Get.toNamed('/account-page', arguments: widget.username);
        //       },
        //     children: generateList(),
        //   ),
        // ),
        SizedBox(height: 5.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  getTime(widget.data.createdAt!),
                  style: TextStyles.interSemiBold12,
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Text(
                        'Ответить',
                        style: TextStyles.interRegular14,
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(PjIcons.commentReply),
                    ],
                  ),
                  onTap: () {
                    SgComments.instance.setIdReply = widget.data.id!;
                    SgComments.instance.setIndexReply = widget.indexReply;
                    SgComments.instance.setNicknameReply = widget.data.nickname!;
                    // GetStorage().write('idReply', widget.data.id!);
                    // GetStorage()
                    //     .write('nicknameReply', widget.data.nickname!);
                    // GetStorage().write('indexReply', widget.indexReply);
                    widget.replyCallback!();
                  },
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: likeDislike,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    Text(
                      widget.data.likes!.toString(),
                      style: TextStyles.interMedium14_808080,
                    ),
                    SizedBox(
                      height: 12.w,
                      child: SvgPicture.asset(widget.data.liked == 0
                          ? PjIcons.heart
                          : PjIcons.likedHeart, color: PjColors.grey3,),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void likeDislike() async {
    setState(() {
      if (widget.data.liked == 0) {
        widget.data.liked = 1;
        widget.data.likes = widget.data.likes! + 1;
        Api.post(
            method: 'comments/${widget.data.id}/like',
            testMode: false,
            isAuth: true,
            body: {});
        return;
      } else {
        widget.data.liked = 0;
        widget.data.likes = widget.data.likes! - 1;
        Api.delete(
          method: 'comments/${widget.data.id}/like',
          testMode: false,
          isAuth: true,
        );
        return;
      }
    });
  }

  List<TextSpan> generateList() {
    print("============ Наш маленький секрет =========");
    List<TextSpan> lst = [];
    List<String> txt = widget.data.comment!.replaceAll("@", " @").split(" ");
    int len = 0;

    for (int i = 0; i < txt.length; i++) {
      try {
        len += txt[i].length;

        if (txt[i][0] == "@") {
          lst.add(TextSpan(
            text: txt[i] + " ",
            style: TextStyles.interSemiBold14,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (SgUser.instance.user.nickname ==
                    txt[i].replaceAll("@", "")) {
                  print("Качнуло 2");
                  navigateToNav(initIndex: 4);
                  // Get.offAll(() => NavigationScreen(
                  //       init: 4,
                  //     ));
                  return;
                }
                print("Качнуло");
                Get.to(
                    () => ProfileScreenProvider(
                        nickname: txt[i].replaceAll("@", "")),
                    transition: tr.Transition.cupertino);
              },
          ));
        } else {
          lst.add(TextSpan(
            text: txt[i] + " ",
            style: TextStyles.interRegular14o70,
          ));
        }
      } catch (e) {}
    }
    return lst;
  }
}
