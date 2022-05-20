import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class SearchFeedScreen extends StatefulWidget {
  final List<PostModel> postModel;
  final int initIndex;
  final int offset;
  final bool isNavBar;

  const SearchFeedScreen(
      {Key? key,
      required this.postModel,
      required this.offset,
      required this.initIndex,
      required this.isNavBar})
      : super(key: key);

  @override
  _SearchFeedScreenState createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  PostController postController = Get.put(PostController(), tag: 'searchFeed');

  @override
  void initState() {
    super.initState();
    log(widget.initIndex.toString(), name: "index");
    postController.posts = widget.postModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PjAppBar(
        leading: true,
        title: 'вернуться',
        bottomLine: true,
      ),
      body: ScrollablePositionedList.separated(
        itemBuilder: (context, index) {
          return Post(
            deleteCallback: (postId) async {
              try {
                Map<String, dynamic> delete = await Api.delete(
                    method: "posts/${postId ?? widget.postModel[index].id}",
                    isAuth: true);
                setState(() {
                  widget.postModel.removeAt(index);
                });
              } on APIException catch (e) {
                if (e.code == 400) {
                  Map<String, dynamic> error = jsonDecode(e.body);
                  if (error['err'][0] == 4 || error['err'][0] == 5) {
                    Get.offAll(LoginScreenProvider(),
                        transition: tr.Transition.cupertino);
                  }
                }
              } on StateError catch (e) {
                log('SKIP');
              }
            },
            index: index,
            commentsCount: widget.postModel[index].comments!.count,
            tag: 'searchFeed',
            profileFeed: true,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 25.w,
          );
        },
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding:
            EdgeInsets.only(left: 12.w, top: 14.w, right: 12.w, bottom: 100.w),
        itemCount: widget.postModel.length,
        initialScrollIndex: widget.initIndex,
      ),
    );
  }
}
