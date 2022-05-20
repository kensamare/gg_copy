import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/likes_model.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/screens/liked_screen/liked_screen_provider.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';


class LikesBar extends StatelessWidget {
  final int index;
  final String tag;

  LikesBar({
    required this.index,
    required this.tag,
    // required this.liked,
    // required this.likes,
    // required this.image,
    Key? key,
  }) : super(key: key){
    _postController = Get.find(tag: tag);
  }

  // final LikesModel likes;
  // final bool liked;
  // final String image;
  late PostController _postController;
  // final int index;
  // final postsActionsController = Get.find<PostsActionsController>();

  @override
  Widget build(BuildContext context) {
    // if (postsActionsController.feed[index].likes?['users'].length > 0) {
    //   imageUrl =
    //   postsActionsController.feed[index].likes?['users'][0]['avatar'];
    //   username =
    //   postsActionsController.feed[index].likes?['users'][0]['nickname'];
    // }
    return GetBuilder<PostController>(
      init: _postController,
      global: false,
      id: 'likes-bar',
      builder:(_) {
        String nickname = '';
        String image = '';
        if(_postController.posts[index].likes!.users!.isEmpty && _postController.posts[index].liked == 1){
          nickname = SgUser.instance.user.nickname!;
          image = SgUser.instance.user.avatar100!;
        } else if(_postController.posts[index].likes!.count != 0 && _postController.posts[index].likes!.users!.isNotEmpty){
          nickname = _postController.posts[index].likes!.users![0].nickname!;
          image = _postController.posts[index].likes!.users![0].avatar100!;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0.w),
          child: _.posts[index].likes!.count! > 0 ? SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (SgUser.instance.user.nickname == nickname) {
                      navigateToNav(initIndex: 4);
                      // Get.offAll(() => NavigationScreen(
                      //   init: 4,
                      // ));
                      return;
                    }
                    Get.to(()=>ProfileScreenProvider(nickname: nickname),
                        transition: tr.Transition.cupertino);
                    // Get.toNamed('/account-page', arguments: 'df');
                  },
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      image,
                    ),
                    radius: 9,
                  ),
                ),
                SizedBox(width: 6.0.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Грустят ',
                      style: TextStyles.interRegular14,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(()=>LikedScreenProvider(index: index, tag: tag,));
                          // Get.toNamed(
                          //   '/posts-likes',
                          //   arguments: {
                          //     'selfImageUrl': postsActionsController
                          //         .mySelfData?['avatar'],
                          //     'postIndex': index
                          //   },
                          // );
                        },
                      children: <TextSpan>[
                        TextSpan(
                          text: nickname,
                          style: TextStyles.interSemiBold14,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                             Get.to(()=>LikedScreenProvider(index: index, tag: tag,))?.then((value) => _postController.updateAllTags());
                            },
                        ),
                        if (_.posts[index].likes!.count! > 1) TextSpan(
                          text: ' и еще ',
                          style: TextStyles.interRegular14o70,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(()=>LikedScreenProvider(index: index, tag: tag,))?.then((value) => _postController.updateAllTags());
                             // @todo
                              // Get.toNamed(
                              //   '/posts-likes',
                              //   arguments: {
                              //     'selfImageUrl': postsActionsController
                              //         .mySelfData?['avatar'],
                              //     'postIndex': index
                              //   },
                              // );
                            },
                        ),
                        if (_.posts[index].likes!.count! > 1) TextSpan(
                          text: (_.posts[index].likes!.count! - 1).toString(),
                          style: TextStyles.interRegular14o70,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(()=>LikedScreenProvider(index: index, tag: tag,))?.then((value) => _postController.updateAllTags());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ) :
          SizedBox(
            child: Text(
              'Пока никто не грустит',
              style: TextStyles.interRegular14,
            ),
          ),
        );

      },
    );
    //   child: GetBuilder<PostsActionsController>(
    //       init: postsActionsController,
    //       id: 'likes-bar',
    //       builder: (_) {
    //         if (_.feed[index].likes?['count'] > 0 ) {
    //           return SizedBox(
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               GestureDetector(
    //                 onTap: () {Get.toNamed('/account-page', arguments: username);},
    //                 child: CircleAvatar(
    //                   backgroundImage: NetworkImage(
    //                     imageUrl,
    //                   ),
    //                   radius: 9,
    //                 ),
    //               ),
    //               const SizedBox(width: 6.0),
    //               Expanded(
    //                 child: RichText(
    //                   text: TextSpan(
    //                     text: 'Грустят ',
    //                     style: TextStyles.interRegular14,
    //                     recognizer: TapGestureRecognizer()
    //                       ..onTap = () {
    //                         Get.toNamed(
    //                           '/posts-likes',
    //                           arguments: {
    //                             'selfImageUrl': postsActionsController
    //                                 .mySelfData?['avatar'],
    //                             'postIndex': index
    //                           },
    //                         );
    //                       },
    //                     children: <TextSpan>[
    //                       TextSpan(
    //                         text: username,
    //                         style: TextStyles.interSemiBold14,
    //                         recognizer: TapGestureRecognizer()
    //                           ..onTap = () {
    //                             Get.toNamed('/account-page', arguments: username);
    //                           },
    //                       ),
    //                       if (_.feed[index].likes?['count'] > 1) TextSpan(
    //                         text: ' и еще ',
    //                         style: TextStyles.interRegular14o70,
    //                         recognizer: TapGestureRecognizer()
    //                           ..onTap = () {
    //                             Get.toNamed(
    //                               '/posts-likes',
    //                               arguments: {
    //                                 'selfImageUrl': postsActionsController
    //                                     .mySelfData?['avatar'],
    //                                 'postIndex': index
    //                               },
    //                             );
    //                           },
    //                       ),
    //                       if (_.feed[index].likes?['count'] > 1) TextSpan(
    //                         text: (_.feed[index].likes?['count'] - 1).toString(),
    //                         style: TextStyles.interRegular14o70,
    //                         recognizer: TapGestureRecognizer()
    //                           ..onTap = () {
    //                             Get.toNamed(
    //                               '/posts-likes',
    //                               arguments: {
    //                                 'selfImageUrl': postsActionsController
    //                                     .mySelfData?['avatar'],
    //                                 'postIndex': index
    //                               },
    //                             );
    //                           },
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //         }
    //         return SizedBox(
    //           child: Text(
    //             'Пока никто не грустит',
    //             style: TextStyles.interRegular14,
    //           ),
    //         );
    //       }),
    // );
  }
}
