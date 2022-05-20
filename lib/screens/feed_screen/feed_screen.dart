import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_widgets/empty_view.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/favorites_screen/favorites_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_type.dart';
import 'package:gg_copy/screens/profile_screen/cubit/cb_profile_screen.dart';
import 'package:gg_copy/screens/user_list_screen/user_list_screen_provider.dart';
import 'package:gg_copy/ui/models/button_model.dart';
import 'package:gg_copy/ui/models/empty_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart' as g;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../project_utils/text_styles.dart';
import 'cubit/cb_feed_screen.dart';
import 'cubit/st_feed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PostTypeValue gSelect = PostTypeValue.warm;

class FeedScreen extends StatefulWidget {
  RxMenu menuController;

  FeedScreen({Key? key, required this.menuController}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  PostController postController = Get.put(PostController(), tag: 'feed');

  // PostController postController = Get.find(tag: 'feed');

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController scroll = ScrollController();

  // = Get.find<RxMenu>(tag: "menu");

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //   menuController = Get.find<RxMenu>(tag: "menu");
      widget.menuController.addListener(_listenHomeTap);
    });
    // print(ModalRoute.of(context)!.settings.name()
    super.initState();
  }

  @override
  void dispose() {
    widget.menuController.removeListener(_listenHomeTap);
    super.dispose();
  }

  void _listenHomeTap() {
    if (mounted) {
      if (widget.menuController.lastIndex ==
              widget.menuController.currentIndex.value &&
          !widget.menuController.isComment) {
        if (scroll.offset <= 0 &&
            BlocProvider.of<CbFeedScreen>(context).state
                is StFeedScreenLoaded) {
          BlocProvider.of<CbFeedScreen>(context).emit(StFeedScreenLoading());
        } else {
          double dur =
              scroll.offset >= Get.height * 5 ? 500 : scroll.offset / 10;
          dur = dur < 100 ? 100 : dur;
          scroll.animateTo(0,
              duration: Duration(milliseconds: dur.toInt()),
              curve: Curves.linear);
        }
      } else if (widget.menuController.isComment) {
        widget.menuController.isComment = false;
        Get.back(id: 1);
      }
    }
  }

  void _onRefresh() async {
    await BlocProvider.of<CbFeedScreen>(context).getPost(
        subMode: gSelect == PostTypeValue.my,
        isThirdFeed: gSelect == PostTypeValue.all,
        subFavoriteMode: gSelect == PostTypeValue.myFavorite);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await BlocProvider.of<CbFeedScreen>(context)
        .getPost(goNext: true, subMode: gSelect == PostTypeValue.my);
    _refreshController.loadComplete();
  }

  // int select = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PjAppBar(
        action: Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: GestureDetector(
            onTap: () => Get.to(const FavoritesScreenProvider()),
            child: SvgPicture.asset(
              PjIcons.bookmark,
              width: 28.w,
              height: 28.w,
            ),
          ),
        ),
      ),
      body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        BlocConsumer<CbFeedScreen, StFeedScreen>(
          listener: (context, state) {
            if (state is StFeedScreenLoaded) {
              if (gSelect == PostTypeValue.all &&
                  GetStorage().read('isNotFirst') == null) {
                Get.dialog(
                    Center(
                      child: Container(
                        width: 347.w,
                        height: 487.w,
                        decoration: BoxDecoration(
                          color: PjColors.blackAnother,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(19.w),
                              child: GestureDetector(
                                  onTap: () {
                                    GetStorage().write('isNotFirst', true);
                                    Get.back();
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: SvgPicture.asset(PjIcons.exit)),
                            ),
                            SizedBox(
                              height: 57.w,
                            ),
                            Center(
                              child: Text('Всё подряд.',
                                  style: TextStyle(
                                      fontFamily: 'PjInter',
                                      color: Colors.white,
                                      fontSize: 42.w,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(
                              height: 24.w,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 38.w),
                              child: Text(
                                'Эта лента — неизведанные земли, поэтому может попасться всё что угодно.',
                                style: TextStyles.interMedium16_b8,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(left: 18.w, right: 18.w),
                              child: GestureDetector(
                                onTap: () {
                                  GetStorage().write('isNotFirst', true);
                                  Get.back();
                                },
                                child: Container(
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                      color: PjColors.buttonGrey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Хорошо',
                                      style: TextStyles.interMedium14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 18.w, right: 18.w, bottom: 32.w),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    gSelect = GetStorage().read('prevIndex');
                                  });
                                  await BlocProvider.of<CbFeedScreen>(context)
                                      .changeFeed();
                                  Get.back();
                                },
                                child: Container(
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                      color: PjColors.blackAnother,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: PjColors.black1)),
                                  child: Center(
                                    child: Text(
                                      'Вернусь позже',
                                      style: TextStyles.interMedium14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierDismissible: false);
              }
            }
          },
          builder: (context, state) {
            if (state is StFeedScreenLoading) {
              BlocProvider.of<CbFeedScreen>(context).getPost(
                  subMode: gSelect == PostTypeValue.my,
                  isThirdFeed: gSelect == PostTypeValue.all,
                  subFavoriteMode: gSelect == PostTypeValue.myFavorite);
              return const Center(
                child: Loader(),
              );
            }
            if (state is StFeedScreenLoaded) {
              postController.posts = state.posts;
              if (gSelect == PostTypeValue.myFavorite &&
                  postController.posts.isEmpty) {
                return EmptyView(
                    viewModel: EmptyViewModel(
                        title: "близкие",
                        description:
                            "Сюда можно добавить тех, чьи посты вы особенно ждёте",
                        buttons: [
                      ButtonModel(
                          text: "перейти в подписки",
                          action: () {
                            Get.to(
                              () => UserListScreenProvider(
                                  id: SgUser.instance.user.id.toString(),
                                  isFollowers: false),
                            );
                          })
                    ]));
              }

              if (gSelect == PostTypeValue.my && postController.posts.isEmpty) {
                return EmptyView(
                    viewModel: EmptyViewModel(
                        title: "ваша личная лента",
                        description:
                            "Подписывайтесь на интересные профили, чтобы всегда держать их в поле зрения",
                        buttons: [
                      ButtonModel(
                          text: "перейти на главную ленту",
                          action: () {
                            gSelect = PostTypeValue.warm;
                            setState(() {});
                          })
                    ]));
              }

              return SmartRefresher(
                enablePullUp: true,
                controller: _refreshController,
                header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus? mode) {
                    return Container(
                      child: Center(
                          child: Lottie.asset('assets/images/loader.json',
                              width: 50.w)),
                    );
                  },
                ),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    if (mode == LoadStatus.loading) {
                      return Container(
                        height: 55.0.w,
                        child: Center(child: Loader()),
                      );
                    }
                    return Container();
                  },
                ),
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: ListView.separated(
                  controller: scroll,
                  itemBuilder: (context, i) {
                    //Виджет поста
                    return Post(
                      index: i,
                      commentsCount: state.posts[i].comments!.count!,
                      editPostDone: () {
                        BlocProvider.of<CbFeedScreen>(context).getPost(
                            subMode: gSelect == PostTypeValue.my,
                            isThirdFeed: gSelect == PostTypeValue.all);
                      },
                      deleteCallback: (id) {
                        log('TUT');
                        BlocProvider.of<CbFeedScreen>(context)
                            .deletePost(i, postId: id);
                      },
                      showDots: state.posts[i].repost != 1,
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      height: 25.w,
                    );
                  },
                  itemCount: state.posts.length,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.w),
                ),
              );
              //return Container(color: Colors.green);
            }
            if (state is StFeedScreenError) {
              return ErrWidget(
                errorCode: state.error.toString(),
                callback: () {
                  BlocProvider.of<CbFeedScreen>(context).changeFeed();
                },
              );
            }
            return Container(color: Colors.grey);
          },
        ),
        Container(
          width: context.width,
          height: 52.w,
          color: PjColors.background,
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, top: 8.w, bottom: 8.w),
            child: PostType(
              onChange: (select) {
                log('change');
                BlocProvider.of<CbFeedScreen>(context).changeFeed();
              },
            ),
          ),
        ),
      ]),
    );
  }
}
