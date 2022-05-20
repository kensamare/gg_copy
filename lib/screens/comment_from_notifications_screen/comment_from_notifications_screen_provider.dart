import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'comment_from_notifications_screen.dart';
import 'cubit/cb_comment_from_notifications_screen.dart';
import 'package:get/get.dart';

class CommentFromNotificationsScreenProvider extends StatelessWidget {
  final String url;
  final int index;
  final bool notification;
  
  CommentFromNotificationsScreenProvider({
    Key? key,
    required this.url,
    required this.index,
    this.notification = false,
  }) : super(key: key);

  final myPostController =
      Get.put(PostController(), tag: 'myControllerForPosts');

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbCommentFromNotificationsScreen>(
      create: (context) => CbCommentFromNotificationsScreen(),
      child: CommentFromNotificationsScreen(
        showAppBar: true,
        index: index,
        url: url,
        tag: 'myControllerForPosts',
        notification: notification,
      ),
    );
  }
}    
    