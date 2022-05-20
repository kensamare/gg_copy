import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/comment_screen/comment_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';


class PostsPageBuilderScreen extends StatefulWidget {
  int start;

   PostsPageBuilderScreen({Key? key, required this.start}) : super(key: key);

  @override
  _PostsPageBuilderScreenState createState() => _PostsPageBuilderScreenState();
}

class _PostsPageBuilderScreenState extends State<PostsPageBuilderScreen> {
   late PageController controller;
  @override
  PostController posts = Get.find();
  void initState() {
    controller = PageController(initialPage: widget.start);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details){
          log("Произошло событие");
        },
        child: PageView.builder(
            pageSnapping: false,
            scrollDirection: Axis.vertical,
            itemCount: posts.posts.length,
            controller: controller,
            itemBuilder: (context, i){
          return CommentScreenProvider(index: i, showAppbar: false,);
        }),
      )
    );
  }
}
    