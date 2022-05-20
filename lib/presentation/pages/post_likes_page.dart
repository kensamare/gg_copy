// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../bloc_getx/controllers/posts_actions_conttroller.dart';
// import '../../project_utils/text_styles.dart';
// import '../widgets/post_likes_page_widgets/user_bar.dart';
//
// class PostLikesPage extends StatefulWidget {
//   const PostLikesPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<PostLikesPage> createState() => _PostLikesPageState();
// }
//
// class _PostLikesPageState extends State<PostLikesPage> {
//   final postsActionsController = Get.find<PostsActionsController>();
//
//   final arguments = Get.arguments;
//
//   late final int postIndex;
//
//   late final String selfImageUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     double maxMetrics = 0;
//     postIndex = arguments['postIndex'];
//     selfImageUrl = arguments['selfImageUrl'];
//     postsActionsController.getNewLikes(postIndex);
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               // FeedAppBar(
//               //   context,
//               //   imageUrl: selfImageUrl,
//               // ),
//               SizedBox(
//                 height: 40,
//                 child: Center(
//                   child: Text(
//                     'отметки "грусти"',
//                     style: TextStyles.interSemiBold14,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                   ),
//                   child: GetBuilder<PostsActionsController>(
//                       init: postsActionsController,
//                       id: 'likes',
//                       builder: (_) {
//                         return NotificationListener<ScrollUpdateNotification>(
//                           onNotification: (notification) {
//                             if (notification.metrics.pixels >
//                                 notification.metrics.maxScrollExtent - MediaQuery.of(context).size.height &&
//                                 notification.metrics.maxScrollExtent > maxMetrics) {
//                               maxMetrics = notification.metrics.maxScrollExtent;
//                               postsActionsController.getNewLikes(postIndex);
//                             }
//                             return false;
//                           },
//                           child: ListView.builder(
//                             addAutomaticKeepAlives: false,
//                             addRepaintBoundaries: false,
//                             physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//                             itemCount: _.feed[postIndex].likes?['users'].length,
//                             itemBuilder: (BuildContext context, int index1) {
//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10.0),
//                                 child: UserBar(
//                                   nickname: _.feed[postIndex].likes?['users']
//                                       [index1]['nickname'],
//                                   avatarUrl: _.feed[postIndex].likes?['users']
//                                       [index1]['avatar'],
//                                   id: _.feed[postIndex].likes?['users'][index1]
//                                           ['id'] ??
//                                       0,
//                                   name: _.feed[postIndex].likes?['users']
//                                       [index1]['name'],
//                                   canFollow: _.feed[postIndex].likes?['users']
//                                 [index1]['canFollow'],
//                                   postIndex: postIndex,
//                                   index1: index1,
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
