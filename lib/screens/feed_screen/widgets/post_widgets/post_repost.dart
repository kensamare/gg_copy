import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:gg_copy/models/user_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_user_id.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/option_bottom_sheet.dart';

class PostRepost extends StatelessWidget {
  final int index;
  final String tag;
  final PostModel post;
  final void Function(int id)? deleteCallback;
  final PostController? postController;

  const PostRepost(
      {Key? key,
      required this.index,
      required this.post,
      required this.tag,
      required this.deleteCallback,
      this.postController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10.w),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12.w,
                backgroundImage:
                    CachedNetworkImageProvider(post.repostUser!.avatar!),
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                post.repostUser!.nickname!.length > 13
                    ? (post.repostUser!.nickname!.substring(0, 13) + '...')
                    : post.repostUser!.nickname!,
                style: TextStyles.interMedium14,
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                "делится",
                style: TextStyles.interRegular14grey3,
              ),
              SizedBox(width: 6.7.w),
              Container(
                padding: EdgeInsets.only(top: 2.w),
                child: SvgPicture.asset(
                  PjIcons.commentReply,
                  color: PjColors.grey3,
                  width: 10.w,
                  height: 10.w,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  var res = await Get.bottomSheet(OptionBottomSheet(
                    idEditPost: index,
                    tag: tag,
                    index: index,
                    timeCreated: (post.createdAt!),
                    postId: post.repostId!,
                    url: post.url!,
                    userId: post.repostUser!.id!,
                    userNickname: post.repostUser!.nickname!,
                    deleteWithBack: false,
                    isRepost: true,
                    postController: postController,
                    canDelete:
                        post.repostUser!.id == SgUser.instance.user.id ? 1 : 0,
                  ));

                  if (res is bool && deleteCallback != null) {
                    deleteCallback!(post.repostId!);
                  }
                },
                child: SvgPicture.asset(
                  PjIcons.dotsMenu,
                  width: 32.0.w,
                ),
              )
            ],
          ),
          if (post.repostComment != null)
            Container(
              padding: EdgeInsets.only(top: 6.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: PjColors.black3,
                ),
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                width: Get.width,
                child: Text(
                  post.repostComment!,
                  style: TextStyles.interRegular14,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          SizedBox(
            width: 12.w,
          ),
        ]));
  }
}
