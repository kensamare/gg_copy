import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/favorites_screen/controllers/favorites_controller.dart';
import 'package:gg_copy/screens/favorites_screen/cubit/cb_favorites_screen.dart';
import 'package:gg_copy/screens/favorites_screen/cubit/st_favorites_screen.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../project_widgets/error_widget.dart';
import 'widgets/favorites_empty_view.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final _favoritesController =
      Get.put<PostController>(FavoritesController(), tag: 'favorites');
  late final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await context.read<CbFavoritesScreen>().getPost();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await context.read<CbFavoritesScreen>().getPost(goNext: true);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PjAppBar(
        leading: true,
        title: 'Сохранёнки',
        action: const SizedBox(),
        textStyle: TextStyles.interMedium16,
      ),
      body: BlocConsumer<CbFavoritesScreen, StFavoritesScreen>(
        listener: (_, StFavoritesScreen state) {
          if (state is StFavoritesScreenLoaded) {
            _favoritesController.posts = state.posts;
          }
        },
        builder: (
          BuildContext context,
          StFavoritesScreen state,
        ) {
          if (state is StFavoritesScreenLoading) {
            return const Center(child: Loader());
          } else if (state is StFavoritesScreenLoaded) {
            return SmartRefresher(
              enablePullUp: true,
              controller: _refreshController,
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
                      child: const Center(child: Loader()),
                    );
                  }
                  return Container();
                },
              ),
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: state.posts.isEmpty
                  ? FavoritesEmptyView()
                  : ListView.separated(
                      itemBuilder: (context, i) {
                        return Post(
                          tag: 'favorites',
                          index: i,
                          commentsCount: state.posts[i].comments!.count!,
                          editPostDone: () {
                            context.read<CbFavoritesScreen>().getPost();
                          },
                          deleteCallback: (postId) {
                            context.read<CbFavoritesScreen>().deletePost(i);
                          },
                        );
                      },
                      separatorBuilder: (context, i) {
                        return SizedBox(
                          height: 25.w,
                        );
                      },
                      itemCount: state.posts.length,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 14.w),
                    ),
            );
          } else if (state is StFavoritesScreenError) {
            return ErrWidget(
              errorCode: state.error.toString(),
              callback: () {},
            );
          }
          return const ColoredBox(color: Colors.grey);
        },
      ),
    );
  }
}
