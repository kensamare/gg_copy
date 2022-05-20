import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/screens/comment_screen/comment_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/posts_page_builder_screen/posts_page_builder_screen.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
// import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_feed.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_feed_screen.dart';

class PostImgGesture extends StatefulWidget {
  String postUrl;
  int userId;
  int offset;
  int index;
  List<PostModel> postModel;

  PostImgGesture({Key? key, required this.postUrl, required this.index, required this.postModel, required this.userId, required this.offset})
      : super(key: key);

  @override
  State<PostImgGesture> createState() => _PostImgGestureState();
}

class _PostImgGestureState extends State<PostImgGesture> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        log("11111");
        // Get.to(() => PostsFeedScreen(postModel: widget.postModel, index: widget.index, isNavBar: true, idUser: widget.userId, profileController: ,),//CommentScreenProvider(index: widget.index, isBottomNavigation: false,),
        //     transition: tr.Transition.cupertino);
        // Get.to(PostsPageBuilderScreen(start: widget.index, ));
      },
      child: CachedNetworkImage(
        imageUrl: widget.postUrl,
        imageBuilder: (context, pro) => Container(
          width: 123.0.w,
          height: 123.0.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: pro, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
