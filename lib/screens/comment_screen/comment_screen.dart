import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/models/comment_data_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu_avatar.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_reply_widget.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_widget.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:gg_copy/screens/comment_screen/widgets/comment_text_field.dart';
import 'cubit/cb_comment_screen.dart';
import 'cubit/st_comment_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  final int index;
  final bool showAppBar;
  final bool isBottomNavigation;
  final String tag;

  const CommentScreen({
    required this.index,
    Key? key,
    required this.showAppBar,
    this.isBottomNavigation = true,
    this.tag = 'feed',
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late PostController _postController;
  RxMenuAvatar avatarController = Get.find(tag: "menuAvatar");
  int id = 0;
  int offset = 0;
  final _scrollController = ScrollController();
  final _commentKey = GlobalKey();
  final _commentReplyFocusNode = FocusNode();
  final _commentController = TextEditingController();
  String comment = 'Комментариев';

  @override
  void initState() {
    _postController = Get.find(tag: widget.tag);
    print(_postController.posts.length);
    print(_postController.posts[0].user!.nickname);
    id = _postController.posts[widget.index].id!;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      avatarController.comment.value = true;
    });
    super.initState();
  }

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
                    Get.back();
                    avatarController.comment.value = false;
                  },
                )
              : null,
          body: BlocBuilder<CbCommentScreen, StCommentScreen>(
            builder: (context, state) {
              if (state is StCommentScreenLoading) {
                BlocProvider.of<CbCommentScreen>(context)
                    .getComment(id, offset);
                offset += 11;
                return const Center(
                  child: Loader(),
                );
              }
              if (state is StCommentScreenLoaded) {
                if (GetStorage().read('showComments') != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    RenderBox box = _commentKey.currentContext!
                        .findRenderObject() as RenderBox;
                    _scrollController.animateTo(
                        box.size.height + 21 <
                                _scrollController.position.maxScrollExtent
                            ? box.size.height + 21
                            : _scrollController.position.maxScrollExtent,
                        duration: Duration(
                            milliseconds: (box.size.height / 2.5).round()),
                        curve: Curves.linear);
                  });
                  GetStorage().remove('showComments');
                }
                comment = declension(
                    _postController.posts[widget.index].comments!.count!);
                return Container(
                  child: Stack(
                    children: [
                      ListView(
                        controller: _scrollController,
                        physics: widget.showAppBar
                            ? BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics())
                            : NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.w),
                        children: [
                          Post(
                            key: _commentKey,
                            index: widget.index,
                            comment: true,
                            tag: widget.tag,
                            deleteWithBack: true,
                            nestedNav: widget.isBottomNavigation,
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Visibility(
                            visible: _postController
                                    .posts[widget.index].comments!.count! !=
                                0,
                            child: SizedBox(
                              width: Get.width,
                              child: Text(
                                '${(NumberFormat('#,###').format(_postController.posts[widget.index].comments!.count!)).replaceAll(',', ' ')} ${comment}',
                                style: TextStyles.interMedium16_808080
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _postController
                                    .posts[widget.index].comments!.count! !=
                                0,
                            child: SizedBox(
                              height: 12.w,
                            ),
                          ),
                          Visibility(
                            visible: _postController
                                    .posts[widget.index].comments!.count! !=
                                0,
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
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                state.comments[i].replies!
                                                    .length,
                                                (j) => Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: state
                                                                      .comments[
                                                                          i]
                                                                      .replies!
                                                                      .length -
                                                                  1 ==
                                                              j
                                                          ? 0
                                                          : 15.w),
                                                  child: CommentReplyWidget(
                                                    data: state.comments[i]
                                                        .replies![j],
                                                    index: i,
                                                    indexReply: j,
                                                    postIndex: widget.index,
                                                    replyCallback: () {
                                                      SgComments.instance
                                                              .setIdReply =
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
                                          style:
                                              TextStyles.interMedium14_808080,
                                        ),
                                        onTap: () {
                                          BlocProvider.of<CbCommentScreen>(
                                                  context)
                                              .getRepliesComments(
                                            state.comments[i].id!,
                                            id,
                                            state
                                                .comments[i]
                                                .replies![state.comments[i]
                                                        .replies!.length -
                                                    1]
                                                .id!,
                                            i,
                                          );
                                        }),
                                  )
                                ]
                              ],
                            ),
                          if (state.comments.isNotEmpty &&
                              state.comments.length !=
                                  _postController
                                      .posts[widget.index].comments!.count)
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                BlocProvider.of<CbCommentScreen>(context)
                                    .getComment(id, offset);
                                offset += 11;
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
                                postId: id,
                                index: widget.index,
                                replyCommentFocusNode: _commentReplyFocusNode,
                                controller: _commentController,
                              ),
                            ),
                            if (!widget.isBottomNavigation)
                              Container(
                                height: 30.w,
                                color: PjColors.background,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is StCommentScreenError) {
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
