import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/cubit/cb_profile_screen.dart';
import 'package:gg_copy/screens/profile_screen/cubit/st_profile_screen.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'posts_widget/posts_feed_screen.dart';

class ProfileScreenPosts extends StatefulWidget {
  final StProfileScreenLoaded state;
  final PostController postController;
  final String nickName;
  final bool isReorderingMode;

  const ProfileScreenPosts({
    Key? key,
    required this.state,
    required this.nickName,
    required this.postController,
    required this.isReorderingMode,
  }) : super(key: key);

  @override
  State<ProfileScreenPosts> createState() => _ProfileScreenPostsState();
}

class _ProfileScreenPostsState extends State<ProfileScreenPosts> {
  bool get _isCurrentUser => widget.nickName == "self";

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CbProfileScreen>();
    if (_isCurrentUser && widget.isReorderingMode) {
      return ReorderableGridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        onReorder: (int oldIndex, int newIndex) {
          bloc.changeOrderOfImages(oldIndex: oldIndex, newIndex: newIndex);
        },
        children: _buildChildren(isReordering: true).toList(),
      );
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: _buildChildren(isReordering: false).toList(),
    );
  }

  Iterable<Widget> _buildChildren({
    required bool isReordering,
  }) sync* {
    final bloc = context.read<CbProfileScreen>();
    for (int i = 0; i < widget.state.posts.length; i++) {
      yield Container(
        key: ValueKey(i.toString()),
        margin: EdgeInsets.all(isReordering ? 7.w : 0.0),
        decoration: BoxDecoration(
          border: isReordering
              ? Border.all(
                  color: PjColors.grey,
                  width: 1,
                )
              : null,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            final res = await Get.to(
                () => PostsFeedScreen(
                      postModel: widget.state.posts,
                      index: i,
                      isNavBar: false,
                      idUser: widget.state.user.id!,
                      profileController: widget.postController,
                    ),
                transition: tr.Transition.cupertino);
            if (res is bool) {
              bloc.deletePost(
                i,
                widget.nickName,
                _isCurrentUser,
                widget.postController.offset,
              );
            } else {
              bloc.getData(
                widget.nickName,
                _isCurrentUser,
                widget.postController.offset,
                updateHeader: true,
              );
            }
          },
          child: CachedNetworkImage(
            imageUrl: widget.state.posts[i].media250![0],
            imageBuilder: (context, pro) => Container(
              width: 123.0.w,
              height: 123.0.w,
              decoration: BoxDecoration(
                image: DecorationImage(image: pro, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      );
    }
  }
}
