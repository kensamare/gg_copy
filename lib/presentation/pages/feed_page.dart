// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/project_widgets/listview_with_search_page.dart';
//
// import '../../bloc_getx/controllers/posts_actions_conttroller.dart';
// // import '../widgets/feed_page_widgets/feed_posts.dart';
//
// class FeedPage extends StatefulWidget {
//   const FeedPage({Key? key}) : super(key: key);
//
//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   final postsActionsController = Get.put(PostsActionsController());
//   var token = Get.arguments;
//   bool firstRun = true;
//   double maxExtent = 0;
//   final scrollController = ScrollController();
//   bool keepOnValue = false;
//   bool gettingTopPosts = false;
//
//   void getTopPosts() async {
//     await postsActionsController.getFeedPosts(MediaQuery.of(context).size.width - 24);
//     gettingTopPosts = false;
//   }
//
//   @override
//   void initState() {
//     firstRun = true;
//     postsActionsController.token = '4HYb0XcX1RbBq3SV3LkZjh0n2R0sYZT1';
//     postsActionsController.getSelfData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (firstRun) {
//       postsActionsController
//           .getFeedPosts(MediaQuery.of(context).size.width - 24);
//       firstRun = false;
//     }
//     return NotificationListener<ScrollUpdateNotification>(
//       onNotification: (notification) {
//         if (notification.metrics.pixels < -20 && !gettingTopPosts) {
//           gettingTopPosts = true;
//           getTopPosts();
//         }
//         if ((notification.scrollDelta??0) < 0) {
//           maxExtent = 0;
//         }
//         if (notification.metrics.pixels >
//                 notification.metrics.maxScrollExtent - MediaQuery.of(context).size.height &&
//             maxExtent < notification.metrics.maxScrollExtent && (notification.scrollDelta??0) >= 0) {
//           maxExtent = notification.metrics.maxScrollExtent;
//           postsActionsController
//               .getNewFeedPosts(MediaQuery.of(context).size.width - 24);
//           return false;
//         }
//         return false;
//       },
//       child: Container(),
//       // child: AppBarWithSearchPage(
//       //   listViewContent: FeedPosts(scrollController: scrollController),
//       // ),
//     );
//   }
// }
