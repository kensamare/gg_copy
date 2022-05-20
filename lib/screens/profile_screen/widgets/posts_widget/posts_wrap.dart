import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/widgets/post_img_gesture.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/cubit/cb_posts.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/cubit/st_posts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostsWrap extends StatefulWidget {
  SelfModel user;

  PostsWrap({Key? key, required this.user}) : super(key: key);

  @override
  State<PostsWrap> createState() => _PostsWrapState();
}

class _PostsWrapState extends State<PostsWrap> {
  PostController _postController = PostController();
  late int offset;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    offset += 12;
    await BlocProvider.of<CbPosts>(context)
        .getData(widget.user.id.toString(), offset);
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    offset = 0;
    Get.put(_postController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<CbPosts, StPosts>(builder: (context, state) {
        if (state is StPostsLoading) {
          BlocProvider.of<CbPosts>(context)
              .getData(widget.user.id.toString(), offset);
          return Container();
        }
        if (state is StPostsLoaded) {
          log(state.posts.length.toString(), name: "POSTS");
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: false,
            controller: _refreshController,
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
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: state.posts.length,
              padding: EdgeInsets.symmetric(vertical: 32.w),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return PostImgGesture(
                    postUrl: state.posts[index].media!.first, index: index, postModel: state.posts, userId: widget.user.id!, offset: offset,);
              },
            ),
          );
        }
        return Container(
          color: Colors.red,
        );
      }),
    );
  }
}
