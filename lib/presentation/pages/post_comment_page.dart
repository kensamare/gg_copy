// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/project_widgets/column_builder.dart';
// import '../../bloc_getx/controllers/posts_actions_conttroller.dart';
// import '../../project_utils/text_styles.dart';
//
// class PostCommentPage extends StatelessWidget {
//   PostCommentPage({
//     Key? key,
//   }) : super(key: key);
//   final int index = Get.arguments;
//   final bool isAccount = Get.parameters.isNotEmpty;
//   final postsActionsController = Get.find<PostsActionsController>();
//
//   @override
//   Widget build(BuildContext context) {
//     postsActionsController.getNewComments(index);
//     double maxExtent = 0;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               // FeedAppBar(context,
//               //     imageUrl: postsActionsController.mySelfData?['avatar']),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: NotificationListener<ScrollUpdateNotification>(
//                     onNotification: (notification) {
//                       if (notification.metrics.pixels >
//                               notification.metrics.maxScrollExtent -
//                                   MediaQuery.of(context).size.height &&
//                           maxExtent < notification.metrics.maxScrollExtent) {
//                         maxExtent = notification.metrics.maxScrollExtent;
//                         postsActionsController.getNewComments(index);
//                       }
//                       return false;
//                     },
//                     child: ListView(
//                       addAutomaticKeepAlives: false,
//                       addRepaintBoundaries: false,
//                       physics: const AlwaysScrollableScrollPhysics(
//                         parent: BouncingScrollPhysics(),
//                       ),
//                       children: [
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         // Post(
//                         //   indexGlobal: index,
//                         //   showComments: true,
//                         //   isAccount: isAccount,
//                         // ),
//                         GetBuilder<PostsActionsController>(
//                             init: postsActionsController,
//                             id: 'comments',
//                             builder: (_) {
//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 3.0),
//                                 child: ColumnBuilder(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   itemCount:
//                                   (isAccount ? _.accountFeed : _.feed)[index].comments?['data'].length ??
//                                           0,
//                                   itemBuilder: (context, index1) {
//                                     return Column(
//                                       children: [
//                                         const SizedBox(height: 16.0),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 3.0),
//                                           child: RichText(
//                                             text: TextSpan(
//                                               text:
//                                                   '${(isAccount ? _.accountFeed : _.feed)[index].comments?['data'][index1]['nickname']} ',
//                                               style: TextStyles.interSemiBold14,
//                                               recognizer: TapGestureRecognizer()
//                                                 ..onTap = () {
//                                                   Get.toNamed('/account-page',
//                                                       arguments: (isAccount ? _.accountFeed : _.feed)[index]
//                                                               .comments?['data']
//                                                           [index1]['nickname']);
//                                                 },
//                                               children: <TextSpan>[
//                                                 TextSpan(
//                                                   text: (isAccount ? _.accountFeed : _.feed)[index]
//                                                           .comments?['data']
//                                                       [index1]['comment'],
//                                                   style: TextStyles
//                                                       .interRegular14o70,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               );
//                             })
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
