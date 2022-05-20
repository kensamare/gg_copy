import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/models/post_model.dart';

import '../../../project_utils/text_styles.dart';
import '../../comment_screen/comment_screen_provider.dart';
import '../../feed_screen/controllers/post_controller.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class SearchPostCard extends StatelessWidget {
  final PostModel model;

  SearchPostCard({Key? key, required this.model}) : super(key: key);

  PostController _postController = Get.put(PostController(), tag:'search');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // @todo
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _postController.posts = [model];
            Get.to(()=> CommentScreenProvider(index: 0, tag: 'search', isBottomNavigation: false,), transition: tr.Transition.cupertino);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 83.w,
                width: 83.w,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(model.media100![0])),
                      borderRadius: BorderRadius.circular(8.w)),
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 245.w,
                    child: RichText(
                      maxLines: 4,
                      text: TextSpan(
                        text: "${model.user!.nickname} ",
                        style: TextStyles.interSemiBold14,
                        children: [
                          TextSpan(text: model.text!.replaceAll("\n", ""), style: TextStyles.interRegular14_808080),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 11.w),
                  RichText(
                    text: TextSpan(
                      text: "Грустят ",
                      style: TextStyles.interRegular14,
                      children: [
                        TextSpan(text: "${model.likes!.count}", style: TextStyles.interRegular14_808080),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
