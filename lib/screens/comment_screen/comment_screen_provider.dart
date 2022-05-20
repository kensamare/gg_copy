import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'comment_screen.dart';
import 'cubit/cb_comment_screen.dart';
import 'cubit/st_comment_screen.dart';

class CommentScreenProvider extends StatelessWidget {
  final int index;
  final bool showAppbar;
  final bool isBottomNavigation;
  final String tag;

  CommentScreenProvider(
      {required this.index,
      Key? key,
      this.showAppbar = true,
      this.isBottomNavigation = true,
      this.tag = 'feed'})
      : super(key: key) {
    RxMenu menuController = Get.find(tag: "menu");
    menuController.isComment = true;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? BlocProvider<CbCommentScreen>(
            create: (context) => CbCommentScreen(
              tag: tag,
            ),
            child: CommentScreen(
              index: index,
              showAppBar: showAppbar,
              isBottomNavigation: isBottomNavigation,
              tag: tag,
            ),
          )
        : BlocProvider<CbCommentScreen>(
            create: (context) => CbCommentScreen(tag: tag),
            child: CommentScreen(
              index: index,
              showAppBar: showAppbar,
              isBottomNavigation: isBottomNavigation,
              tag: tag,
            ),
          );
  }
}


// onWillPop: () async {
// // print('tut');
// // if (isBottomNavigation) {
// //   Get.back(id: 1);
// //   return false;
// // }
// return true;
// },