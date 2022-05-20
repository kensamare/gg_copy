// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/bloc_getx/controllers/posts_actions_conttroller.dart';
// import 'package:gg_copy/presentation/widgets/account_page_widgets/user_stats_bar.dart';
//
// import '../../project_utils/text_styles.dart';
// import '../widgets/account_page_widgets/account_appbar.dart';
// import '../widgets/account_page_widgets/account_header.dart';
// import '../widgets/account_page_widgets/post_grid.dart';
//
// class AccountPage extends StatefulWidget {
//   const AccountPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<AccountPage> createState() => _AccountPageState();
// }
//
// class _AccountPageState extends State<AccountPage> {
//   final String nickname = Get.arguments;
//   List<String> urls = [];
//   bool firstRun = true;
//
//   final postsActionsController = Get.find<PostsActionsController>();
//
//   @override
//   void initState() {
//     firstRun = true;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               const AccountAppBar(username: 'грустнограм'),
//               Expanded(
//                 child: FutureBuilder<Map>(
//                     future: postsActionsController.getUserData(nickname),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) return const SizedBox();
//                       if (firstRun) {
//                         postsActionsController.getUsersFeed(
//                           MediaQuery.of(context).size.width - 24,
//                           snapshot.data!['id'],
//                         );
//                         firstRun = false;
//                       }
//                       return Column(
//                         children: [
//                           Expanded(
//                             child: ListView(
//                               physics: const AlwaysScrollableScrollPhysics(
//                                 parent: BouncingScrollPhysics(),
//                               ),
//                               children: [
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 AccountHeader(
//                                   imageUrl: snapshot.data!['avatar'],
//                                   nickname: snapshot.data!['nickname'],
//                                   name: snapshot.data!['name'],
//                                   description: snapshot.data!['about'],
//                                   canFollow: snapshot.data!['canFollow'] == 1,
//                                   id: snapshot.data!['id'],
//                                 ),
//                                 const SizedBox(
//                                   height: 32,
//                                 ),
//                                 UserStatsBar(
//                                   posts: snapshot.data!['posts'],
//                                   following: snapshot.data!['follow'],
//                                   followers: snapshot.data!['followers'],
//                                 ),
//                                 const SizedBox(
//                                   height: 32,
//                                 ),
//                                 if (snapshot.data!['posts'] != 0)
//                                   PostGrid(
//                                     id: snapshot.data!['id'],
//                                   ),
//                                 if (snapshot.data!['nickname'] ==
//                                         postsActionsController
//                                             .mySelfData?['nickname'] &&
//                                     snapshot.data!['posts'] == 0)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 14.0,
//                                     ),
//                                     child: DottedBorder(
//                                       color: const Color(0x4d808080),
//                                       radius: const Radius.circular(10.0),
//                                       borderType: BorderType.RRect,
//                                       child: const ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             const Radius.circular(10)),
//                                         child: SizedBox(
//                                           height: 88,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 if (snapshot.data!['posts'] == 0)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 34),
//                                     child: Column(
//                                       children: [
//                                         const SizedBox(
//                                           height: 32,
//                                         ),
//                                         SizedBox(
//                                           width: 250,
//                                           child: Text(
//                                             'если нет грустных фото, почитайте грустный стих',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyles
//                                                 .interRegular14_808080,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 32,
//                                         ),
//                                         Text(
//                                           snapshot.data!['poem']['title'],
//                                           textAlign: TextAlign.center,
//                                           style: TextStyles.interMedium20,
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         Text(
//                                           snapshot.data!['poem']['poem'],
//                                           style: TextStyles.interMedium16o70,
//                                         ),
//                                         const SizedBox(
//                                           height: 16,
//                                         ),
//                                         CircleAvatar(
//                                           radius: 16,
//                                           backgroundImage: NetworkImage(
//                                             snapshot.data!['poem']['avatar'],
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 6,
//                                         ),
//                                         Text(
//                                           snapshot.data!['poem']['author'],
//                                           style: TextStyles.interRegular14,
//                                         ),
//                                         const SizedBox(
//                                           height: 6,
//                                         ),
//                                         Text(
//                                           snapshot.data!['poem']['year']
//                                               .toString(),
//                                           style:
//                                               TextStyles.interRegular12_808080,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
