// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/bloc_getx/controllers/posts_actions_conttroller.dart';
//
//
// class AppBarWithSearchPage extends StatefulWidget {
//   AppBarWithSearchPage({
//     Key? key,
//     this.listViewContent,
//   }) : super(key: key);
//
//   final Widget? listViewContent;
//
//   @override
//   State<AppBarWithSearchPage> createState() => _AppBarWithSearchPageState();
// }
//
// class _AppBarWithSearchPageState extends State<AppBarWithSearchPage>
//     with TickerProviderStateMixin {
//   late final AnimationController feedAnimController;
//   late final AnimationController updateAnimController;
//   final postActionController = Get.find<PostsActionsController>();
//   final TextEditingController searchTextController = TextEditingController();
//
//   @override
//   void initState() {
//     feedAnimController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 0),
//     );
//     updateAnimController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 0),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   const SizedBox(
//                     height: 60,
//                   ),
//                   Expanded(
//                     child: NotificationListener<ScrollEndNotification>(
//                       onNotification: (notification) {
//                         if (notification.metrics.axis == Axis.vertical) {
//                           if (feedAnimController.value < 0.35 ||
//                               notification.metrics.pixels < 5.0) {
//                             feedAnimController.animateTo(
//                               0,
//                               duration: const Duration(milliseconds: 200),
//                             );
//                           } else {
//                             feedAnimController.animateTo(
//                               1,
//                               duration: const Duration(milliseconds: 200),
//                             );
//                           }
//                         }
//                         return true;
//                       },
//                       child: NotificationListener<ScrollUpdateNotification>(
//                         onNotification: (notification) {
//                           if (notification.metrics.axis == Axis.vertical) {
//                             if (!notification.metrics.outOfRange) {
//                               feedAnimController.animateTo(
//                                   feedAnimController.value +
//                                       (notification.scrollDelta ?? 0) / 200);
//                             }
//                           }
//                           return false;
//                         },
//                         child:  Obx(() {
//                             return postActionController.searchValue.value.isEmpty
//                                     ? widget.listViewContent ?? const SizedBox()
//                                     : SearchedAccounts();
//                           }
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   AnimatedBuilder(
//                     animation: feedAnimController,
//                     builder: (context, child) {
//                       return Transform.translate(
//                         offset: Offset(
//                           0,
//                           feedAnimController.value * -50,
//                         ),
//                         transformHitTests: false,
//                         child: child,
//                       );
//                     },
//                     child: Container(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 6.0,
//                       ),
//                       child: Center(
//                         child: SearchTextField(
//                           textEditingController: searchTextController,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   GetBuilder<PostsActionsController>(
//                       init: postActionController,
//                       id: 'self_avatar',
//                       builder: (_) {
//                         // return FeedAppBar(
//                         //   context,
//                         //   imageUrl: _.mySelfData?['avatar'] ??
//                         //       'https://560621.selcdn.ru/gg_250/empty_profile.jpg',
//                         // );
//                         return Container();
//                       }),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
