import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/comment_screen/comment_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'feed_screen.dart';
import 'cubit/cb_feed_screen.dart';
import 'cubit/st_feed_screen.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class FeedScreenProvider extends StatelessWidget {
  FeedScreenProvider({Key? key, required this.menuController}) : super(key: key);
  RxMenu menuController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbFeedScreen>(
      create: (context) => CbFeedScreen(),
      child: Navigator(
          key: Get.nestedKey(SgNested.instance.id), // create a key by index
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/posts' || settings.name == '/') {
              return GetPageRoute(
                page: () => FeedScreen(
                  menuController: menuController,
                ),
              );
            } else if (settings.name == '/comment') {
              return GetPageRoute(
                page: () => CommentScreenProvider(
                  index: settings.arguments as int,
                ),
                popGesture: true,
                transition: tr.Transition.cupertino,
              );
            }
          }),
    );
  }
}
