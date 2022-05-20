// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/bloc_getx/controllers/posts_actions_conttroller.dart';
//
// import '../../../project_utils/text_styles.dart';
//
// class UserBar extends StatefulWidget {
//   const UserBar({
//     Key? key,
//     required this.id,
//     required this.avatarUrl,
//     required this.nickname,
//     this.name,
//     required this.canFollow,
//     this.postIndex,
//     this.index1,
//   }) : super(key: key);
//
//   final int id;
//   final String avatarUrl;
//   final String nickname;
//   final String? name;
//   final int canFollow;
//   final int? postIndex;
//   final int? index1;
//
//   @override
//   State<UserBar> createState() => _UserBarState();
// }
//
// class _UserBarState extends State<UserBar> {
//   int canFollow = 0;
//   final postsActionController = Get.find<PostsActionsController>();
//
//   @override
//   void initState() {
//     canFollow = widget.canFollow;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 48,
//       child: Row(
//         children: [
//           GestureDetector(
//             child: CircleAvatar(
//               radius: 24,
//               backgroundImage: NetworkImage(
//                 widget.avatarUrl,
//               ),
//             ),
//             onTap: () {
//               Get.toNamed('/account-page', arguments: widget.nickname);
//             },
//           ),
//           const SizedBox(
//             width: 12.0,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   child: Text(
//                     widget.nickname,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyles.interMedium14,
//                   ),
//                   onTap: () {
//                     Get.toNamed('/account-page', arguments: widget.nickname);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   widget.name ?? '',
//                   maxLines: 1,
//                   style: TextStyles.interRegular12_808080,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             width: 12.0,
//           ),
//           Container(
//             width: 104,
//             height: 28,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 border: Border.all(
//                   color: canFollow == 1 ? Colors.transparent : Colors.white,
//                 )),
//             child: CupertinoButton(
//               color: canFollow == 1
//                   ? Theme.of(context).canvasColor
//                   : Colors.transparent,
//               padding: EdgeInsets.zero,
//               child: Text(
//                 canFollow == 1 ? 'Подписаться' : 'Отписаться',
//                 style: TextStyles.interRegular12,
//               ),
//               onPressed: () {
//                 if (canFollow == 1) {
//                   postsActionController.followAccount(widget.id);
//                   if (widget.postIndex != null) {
//                     postsActionController.feed[widget.postIndex!].likes?['users']
//                       [widget.index1]['canFollow'] = 0;
//                   }
//                 } else {
//                   postsActionController.unfollowAccount(widget.id);
//                   if (widget.postIndex != null) {
//                     postsActionController.feed[widget.postIndex!].likes?['users']
//                       [widget.index1]['canFollow'] = 1;
//                   }
//                 }
//                 setState(() {
//                   canFollow = canFollow == 0 ? 1 : 0;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
