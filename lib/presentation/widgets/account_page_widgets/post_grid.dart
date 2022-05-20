// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../bloc_getx/controllers/posts_actions_conttroller.dart';
//
// class PostGrid extends StatelessWidget {
//   PostGrid({
//     Key? key, this.id,
//   }) : super(key: key);
//
//   final dynamic id;
//   final postsActionsController = Get.find<PostsActionsController>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//       child: GetBuilder<PostsActionsController>(
//         init: postsActionsController,
//         id: 'account-grid',
//         builder: (_) {
//           return GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 mainAxisSpacing: 2,
//                 crossAxisSpacing: 2,
//                 crossAxisCount: 3,
//             ),
//             itemCount: _.accountFeed.length,
//             itemBuilder: (context, index) {
//               return CupertinoButton(
//                 pressedOpacity: 0.7,
//                 padding: EdgeInsets.zero,
//                 child: Container(
//                   height: (MediaQuery.of(context).size.width - 8)/3,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(_.accountFeed[index].media?[0],),
//                     ),
//                   ),
//                 ),
//                 onPressed: () {
//                   Get.toNamed('/post-comment-page', arguments: index, parameters: {'isAccount' : 'yes'});
//                 },
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
// }
