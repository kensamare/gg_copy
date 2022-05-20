import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu_avatar.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/cubit/cb_feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/likes_bar.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/post_actions_bar.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/post_description_bar.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/post_repost.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/post_top_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../comment_screen/comment_screen_provider.dart';

class Post extends StatefulWidget {
  Post({
    this.commentsCount,
    required this.index,
    this.comment = false,
    this.tag = 'feed',
    this.profileFeed = false,
    this.deleteWithBack = false,
    this.deleteCallback,
    this.nestedNav = false,
    this.editPostDone,
    this.showDots = true,
    Key? key,
  }) : super(key: key);

  final int? commentsCount;
  final int index;
  final bool comment;
  final String tag;
  final bool profileFeed;
  final bool deleteWithBack;
  final Function(int? postId)? deleteCallback;
  final Function()? editPostDone;
  final bool nestedNav;
  final bool showDots;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with TickerProviderStateMixin {
  final pageController = PageController(viewportFraction: 1.05);
  late AnimationController heartAnimController;
  late PostController _postController;
  late int index;

  @override
  void initState() {
    index = widget.index;
    heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 933),
    );
    heartAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        heartAnimController.reset();
      }
    });
    _postController = Get.find(tag: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = 300.w;
    if (_postController.posts[index].h != null &&
        _postController.posts[index].w != null) {
      if (_postController.posts[index].h! > 10 &&
          _postController.posts[index].w! > 10)
        height =
            ((Get.width - 24.w) / _postController.posts[index].w!.toDouble()) *
                _postController.posts[index].h!;
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_postController.posts[index].repost == 1)
            PostRepost(
                index: index,
                post: _postController.posts[index],
                tag: widget.tag,
                postController: _postController,
                deleteCallback: widget.deleteCallback),
          PostTopBar(
              index: index,
              user: _postController.posts[index].user!,
              tag: widget.tag,
              deleteWithBack: widget.deleteWithBack,
              deleteCallback: widget.deleteCallback,
              editPostDone: widget.editPostDone,
              nestedNav: widget.nestedNav,
              showDots: widget.showDots),
          SizedBox(
            height: 10.w,
          ),
          ZoomOverlay(
            maxScale: 3,
            minScale: 1,
            twoTouchOnly: true,
            child: SizedBox(
              height: height,
              child: PageView.builder(
                  itemCount: _postController.posts[index].media!.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onDoubleTap: () async {
                        if (await Vibrate.canVibrate) {
                          Vibrate.feedback(FeedbackType.light);
                        }
                        if (_postController.posts[index].liked != 1)
                          _postController.switchPostLike(index, (e) {
                            BlocProvider.of<CbFeedScreen>(context)
                                .throwError(e);
                          });
                        if (mounted) {
                          heartAnimController.forward();
                        }
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12.0.w,
                              ),
                              child: Image(
                                image: CachedNetworkImageProvider(
                                  _postController.posts[index].media![i],
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Center(
                            child: Lottie.asset(
                              'assets/images/doubletap.json',
                              width: 150.w,
                              repeat: false,
                              controller: heartAnimController,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          PostActionsBar(
            profileFeed: widget.profileFeed,
            index: index,
            comment: widget.comment,
            tag: widget.tag,
            deleteCallback: widget.deleteCallback,
            // index: widget.indexGlobal,
          ),
          LikesBar(
            index: index,
            tag: widget.tag,
          ),
          GetBuilder<PostController>(
            init: _postController,
            global: false,
            id: 'description',
            builder: (_) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: PostDescriptionBar(
                username: _postController.posts[index].user!.nickname!,
                description: _postController.posts[index].text ?? '',
                showFullDescription: widget.comment,
                links: _postController.posts[index].links!,
                tag: widget.tag,
              ),
            ),
          ),
          if (!widget.comment) ...[
            SizedBox(
              height: 5.w,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                GetStorage().write('showComments', true);
                log(widget.profileFeed.toString(), name: "profileFeed");
                var res = !widget.profileFeed
                    ? await Get.toNamed(
                        '/comment',
                        arguments: index,
                        id: SgNested.instance.id,
                      )
                    : Get.to(CommentScreenProvider(
                        index: widget.index,
                        tag: widget.tag,
                        isBottomNavigation: false,
                      ));
                if (res is bool && widget.deleteCallback != null) {
                  widget.deleteCallback!(null);
                  return;
                }
                _postController.updateAllTags();
                RxMenuAvatar cntrl = Get.find(tag: "menuAvatar");
                cntrl.comment.value = false;
              },
              child: GetBuilder<PostController>(
                init: _postController,
                global: false,
                id: 'comments_count',
                builder: (_) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.w),
                  child: Text(
                    'Комментарии: ${_.posts[index].comments!.count}',
                    style:
                        TextStyles.interRegular14_808080.copyWith(height: 0.95),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
