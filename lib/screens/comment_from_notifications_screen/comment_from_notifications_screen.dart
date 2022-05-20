import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu_avatar.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/cubit/cb_comment_from_notifications_screen.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/cubit/st_comment_from_notifications_screen.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_reply_widget.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_widget.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_text_field.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CommentFromNotificationsScreen extends StatefulWidget {
  final int index;
  final bool showAppBar;
  final bool isBottomNavigation;
  final String tag;
  final String url;
  final bool notification;

  const CommentFromNotificationsScreen({
    required this.index,
    Key? key,
    required this.showAppBar,
    required this.url,
    this.isBottomNavigation = false,
    required this.notification,
    this.tag = 'feed',
  }) : super(key: key);

  @override
  _CommentFromNotificationsScreenState createState() =>
      _CommentFromNotificationsScreenState();
}

class _CommentFromNotificationsScreenState
    extends State<CommentFromNotificationsScreen> {
  late final PostController _postController = Get.find(tag: widget.tag);
  final _commentReplyFocusNode = FocusNode();
  final _commentController = TextEditingController();
  
  RxMenuAvatar avatarController = Get.find(tag: "menuAvatar");
  int id = 0;
  int offset = 0;
  int offSetFromNotifications = 0;
  int index = 0;
  String comment = 'Комментариев';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SgComments.instance.reset();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: widget.showAppBar
              ? PjAppBar(
                  title: 'вернуться',
                  leading: true,
                  navId: !widget.isBottomNavigation ? null : 1,
                  onBack: () {
                    SgComments.instance.reset();
                    avatarController.comment.value = false;
                  },
                )
              : null,
          body: BlocBuilder<CbCommentFromNotificationsScreen,
              StCommentFromNotificationsScreen>(
            builder: (context, state) {
              if (state is StCommentFromNotificationsScreenLoading) {
                offSetFromNotifications += 3;
                offset += 11;

                BlocProvider.of<CbCommentFromNotificationsScreen>(context)
                    .getComment(widget.url);
                return const Center(
                  child: Loader(),
                );
              }
              if (state is StCommentFromNotificationsScreenLoaded) {
                _postController.posts = state.postModel;
                // if (_postController.posts[0].comments!.count! % 3 == 0) {
                //   offSetFromNotifications += 3;
                // } else {
                //   offSetFromNotifications += _postController.posts[0].comments!.count! % 3;
                // }
                comment = declension(_postController.posts[0].comments!.count!);
                return Stack(
                  children: [
                    ListView(
                      physics: widget.showAppBar
                          ? BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics())
                          : NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.w),
                      children: [
                        Post(
                          index: 0,
                          comment: true,
                          tag: widget.tag,
                          deleteWithBack: false,
                          deleteCallback: (postId) {
                            BlocProvider.of<CbCommentFromNotificationsScreen>(
                                    context)
                                .deletePost(0, widget.notification ? 0 : 3);
                          },
                        ),
                        SizedBox(
                          height: 20.w,
                        ),
                        Visibility(
                          visible: _postController.posts[0].comments!.count! != 0,
                          child: SizedBox(
                            width: Get.width,
                            child: Text(
                              '${(NumberFormat('#,###').format(_postController.posts[0].comments!.count!)).replaceAll(',', ' ')} ${comment}',
                              style: TextStyles.interMedium16_808080
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _postController.posts[0].comments!.count! != 0,
                          child: SizedBox(
                            height: 12.w,
                          ),
                        ),
                        Visibility(
                          visible: _postController.posts[0].comments!.count! != 0,
                          child: Container(
                            height: 1.w,
                            color: PjColors.lightGrey,
                            margin: EdgeInsets.only(bottom: 13.w),
                          ),
                        ),
                        for (int i = 0; i < state.comments.length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommentWidget(
                                data: state.comments[i],
                                index: i,
                                postIndex: widget.index,
                                isFromNotifications: true,
                                replyCallback: () {
                                  FocusScope.of(context)
                                      .requestFocus(_commentReplyFocusNode);
                                },
                              ),
                              state.comments[i].repliesCount! != 0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: 13.w, bottom: 15.w),
                                      child: Container(
                                        width: 338.w,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              width: 1.w,
                                              color: PjColors.black2,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              state.comments[i].replies!.length,
                                              (j) => Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: state
                                                                    .comments[i]
                                                                    .replies!
                                                                    .length -
                                                                1 ==
                                                            j
                                                        ? 0
                                                        : 15.w),
                                                child: CommentReplyWidget(
                                                  data: state
                                                      .comments[i].replies![j],
                                                  index: i,
                                                  indexReply: j,
                                                  postIndex: widget.index,
                                                  isFromNotifications: true,
                                                  replyCallback: () {
                                                    SgComments
                                                            .instance.setIdReply =
                                                        state.comments[i].id!;
                                                    SgComments.instance
                                                        .setIndexReply = i;

                                                    // GetStorage().write('idReply', state.comments[i].id);
                                                    // GetStorage().write('indexReply', i);
                                                    _commentController.text =
                                                        '@${SgComments.instance.getNicknameReply.toString()}, ';
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              if (state.comments[i].replies!.isNotEmpty &&
                                  state.comments[i].replies!.length !=
                                      state.comments[i].repliesCount!) ...[
                                Padding(
                                  padding: EdgeInsets.only(left: 34.w),
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Text(
                                        'Показать ещё ответы',
                                        style: TextStyles.interMedium14_808080,
                                      ),
                                      onTap: () {
                                        BlocProvider.of<
                                                    CbCommentFromNotificationsScreen>(
                                                context)
                                            .getRepliesComments(
                                          state.comments[i].id!,
                                          id,
                                          state
                                              .comments[i]
                                              .replies![state.comments[i].replies!
                                                      .length -
                                                  1]
                                              .id!,
                                          i,
                                        );
                                      }),
                                )
                              ]
                            ],
                          ),

                        // CommentWidget(
                        //   offset: offSetFromNotifications,
                        //   data: state.comments[i],
                        //   index: i,
                        //   postIndex: widget.index,
                        //   deleteCallback: BlocProvider.of<CbCommentFromNotificationsScreen>(context).deleteComment,
                        //   isFromNotifications: true,
                        //
                        // ),
                        if (state.comments.isNotEmpty &&
                            state.comments.length !=
                                _postController.posts[0].comments!.count)
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              log(state.comments.length.toString(),
                                  name: "commentsLength");
                              log(
                                  _postController.posts[0].comments!.count
                                      .toString(),
                                  name: "commentCount");
                              BlocProvider.of<CbCommentFromNotificationsScreen>(
                                      context)
                                  .getNewComments(
                                      _postController.posts[index].id!,
                                      offSetFromNotifications);
                              offset += 11;
                              offSetFromNotifications += 3;
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.w,
                                      color: PjColors.lightGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'загрузить еще комментарии',
                                    style: TextStyles.interRegular14_808080
                                        .copyWith(height: 0.95),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.w,
                                      color: PjColors.lightGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 160.w,
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isBottomNavigation)
                              Container(
                                color: PjColors.lightGrey,
                                height: 1.w,
                              ),
                            Container(
                                width: Get.width,
                                padding: EdgeInsets.only(
                                    top: 8.w,
                                    left: 14.w,
                                    right: 14.w,
                                    bottom: 4.w),
                                color: PjColors.background,
                                child: CommentTextField(
                                  controller: _commentController,
                                  replyCommentFocusNode: _commentReplyFocusNode,
                                  postId: _postController.posts[index].id!,
                                  index: 0,
                                  isFromNotifications: true,
                                  sendComment: BlocProvider.of<
                                              CbCommentFromNotificationsScreen>(
                                          context)
                                      .sendComment,
                                )),
                            if (!widget.isBottomNavigation)
                              Container(
                                height: 30.w,
                                color: PjColors.background,
                              ),
                          ],
                        )),
                  ],
                );
              }
              if (state is StCommentFromNotificationsScreenError) {
                return ErrWidget(
                  errorCode: state.error.toString(),
                  callback: () {
                    if (!widget.isBottomNavigation) {
                      Get.back();
                    } else
                      Get.back(id: SgNested.instance.id);
                  },
                );
              }
              return Container(color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  String declension(int num) {
    num %= 100;
    if (num >= 5 && num <= 20) {
      return 'Комментариев';
    }
    num %= 10;
    if (num == 1) {
      return 'Комментарий';
    }
    if (num >= 2 && num <= 4) {
      return 'Комментария';
    }
    return 'Комментариев';
  }
}
