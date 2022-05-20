import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_user_id.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/widgets/add_post.dart';
import 'package:gg_copy/screens/profile_screen/widgets/header_prifile.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_feed_screen.dart';
import 'package:gg_copy/screens/profile_screen/widgets/profile_screen_posts.dart';
import 'package:gg_copy/screens/profile_screen/widgets/setting_bottom_sheet.dart';
import 'package:gg_copy/screens/profile_screen/widgets/verse_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../project_utils/pj_colors.dart';
import '../../project_utils/pj_icons.dart';
import '../feed_screen/widgets/post_widgets/option_bottom_sheet.dart';
import '../share_screen/share_screen.dart';
import 'cubit/cb_profile_screen.dart';
import 'cubit/st_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class ProfileScreen extends StatefulWidget {
  final String nickname;
  final bool isMenu;
  final String tag;

  const ProfileScreen({
    required this.nickname,
    this.isMenu = false,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isSelf;
  late SelfModel? localUser;
  bool isBlock = false;
  int userId = 0;
  RxUserId userIdController = Get.find(tag: "userId");

  late PostController postController;

  @override
  void initState() {
    isSelf = widget.nickname == "self";
    if (SgUser.instance.user.nickname == widget.nickname) {
      isSelf = true;
    }
    postController = Get.find(tag: widget.tag);
    postController.offset = 0;
    if (isSelf) {
      localUser = SgUser.instance.user;
      if (localUser!.id == null) {
        isSelf = false;
      }
    }

    log(userId.toString(), name: "userId");
    super.initState();
  }

  final _refreshController = RefreshController(initialRefresh: false);

  void _onLoading() async {
    log(postController.offset.toString(), name: 'offset');
    await BlocProvider.of<CbProfileScreen>(context).getPost(postController.offset);
    postController.offset += 15;
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    postController.offset = 0;
    await BlocProvider.of<CbProfileScreen>(context).getData(
      widget.nickname,
      widget.nickname == "self",
      postController.offset,
      updateHeader: true,
    );
    postController.offset += 15;
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CbProfileScreen>();
    log(widget.tag.toString(), name: "PROFILETAG");
    return Scaffold(
      appBar: PjAppBar(
        userId: userIdController.userId.value,
        isNotSelf: !isSelf,
        leading: !widget.isMenu,
        nickname: widget.nickname,
        action: isSelf
              ? BlocBuilder<CbProfileScreen, StProfileScreen>(
                  builder: (context, state) {
                    if (state is StProfileScreenLoaded) {

                      return Row(children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => ShareScreen(),
                                transition: tr.Transition.cupertino);
                          },
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SvgPicture.asset(PjIcons.repost,
                                  width: 14, height: 14),
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Future<void> Function() deleteSession =
                                bloc.deleteSession;
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return SettingBottomSheet(
                                  deleteSession: deleteSession,
                                  isSelf: isSelf,
                                  userId: state.user.id!,
                                  userNickname: state.user.nickname!,
                                  bloc: () {
                                    bloc.emit(StProfileScreenLoading());
                                  },
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SvgPicture.asset(PjIcons.menu,
                                  width: 14, height: 14),
                            ),
                          ),
                        )
                      ]);
                    }
                
                    return const SizedBox();
                  },
                )
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.bottomSheet(OptionBottomSheet(
                      postId: 0,
                      url: '',
                      userId: userId,
                      userNickname: widget.nickname,
                      deleteWithBack: false,
                      isNotSelf: !isSelf,
                    ));
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: 18.5.w, top: 15.w, bottom: 15.w),
                    child: Row(children: [
                      for (int i = 0; i < 3; i++) ...[
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: PjColors.white),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                      ]
                    ]),
                  ),
                )
      ),
      body: BlocBuilder<CbProfileScreen, StProfileScreen>(
        builder: (context, state) {
          if (state is StProfileScreenLoading) {
            postController.offset = 0;
            BlocProvider.of<CbProfileScreen>(context).getData(
              widget.nickname,
              widget.nickname == "self",
              postController.offset,
            );
            postController.offset += 15;
            return const Center(
              child: Loader(),
            );
          }
          if (state is StProfileScreenLoaded) {
            userIdController.userId.value = state.user.id!;
            log(userIdController.userId.value.toString(), name: "changeUserId");
            postController.posts = state.posts;
            postController.user = state.user;
            return SizedBox(
              width: Get.width,
              child: SmartRefresher(
                enablePullUp: true,
                onLoading: _onLoading,
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus? mode) {
                    return Center(
                      child: Lottie.asset(
                        'assets/images/loader.json',
                        width: 50.w,
                      ),
                    );
                  },
                ),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    if (mode == LoadStatus.loading) {
                      return SizedBox(
                        height: 55.0.w,
                        child: const Loader(),
                      );
                    }
                    return SizedBox(
                      height: 1.w,
                    );
                  },
                ),
                child:  state.user.blocked == 1 ? HeaderProfile(
                  user: state.user,
                  isSelf: isSelf,
                  tag: widget.tag,
                  postController: postController,
                  nickname: widget.nickname,
                  offset: postController.offset,
                        isReorderPostsMode: false,
                        onReorderModeChange: (_) {},
                ) : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    HeaderProfile(
                      user: state.user,
                      isSelf: isSelf,
                      tag: widget.tag,
                      postController: postController,
                      nickname: widget.nickname,
                      offset: postController.offset,
                            isReorderPostsMode: state.isReorderingMode,
                            onReorderModeChange: (isReorderingMode) {
                              bloc.changePostOrderMode(isReorderingMode);
                            },
                    ),
                    isSelf
                        ? state.user.posts == 0
                                  ? const AddPost()
                                  : const SizedBox()
                              : const SizedBox(),
                    SizedBox(
                      height: 32.w,
                    ),
                    state.posts.isEmpty
                        ? VerseWidget(poem: state.user.poem!)
                              : ProfileScreenPosts(
                                  postController: postController,
                                  nickName: widget.nickname,
                                  state: state,
                                  isReorderingMode: state.isReorderingMode,
                                ),
                  ],
                ),
              ),
            );
          }
          if (state is StProfileScreenError) {
            return ErrWidget(
              errorCode: state.error.toString(),
            );
          }
          return const ColoredBox(color: Colors.grey);
        },
      ),
    );
  }
}
