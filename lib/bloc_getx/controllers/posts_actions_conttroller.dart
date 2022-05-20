// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// import '../../data/posts.dart';
// import '../models/post_model.dart';
//
// class PostsActionsController extends GetxController {
//   late String token;
//   var feed = <PostModel>[].obs;
//   var accountFeed = <PostModel>[].obs;
//   var searchedAccounts = [].obs;
//   var searchValue = ''.obs;
//   Map? mySelfData;
//   dynamic id;
//
//   void getSearchedAccounts() async{
//     searchedAccounts.value = [];
//     searchedAccounts.value = await Posts.getSearchedUsers(token, searchValue.value);
//     print(searchedAccounts.value);
//   }
//
//   void getNewFeedPosts(double screenWidth) async {
//     var posts = await Posts.getFeedPosts(token, feed.length, null) ?? [];
//     for (var i in posts) {
//       bool duplicate = false;
//       var model = await dataToModel(i);
//       for (var j in feed) {
//         if (j.id == model.id) {
//           duplicate = true;
//           break;
//         }
//       }
//       if (!duplicate) {
//         feed.add(model);
//       }
//     }
//     if (posts.isNotEmpty) {
//       for (int i = 0; i < feed.length; i++) {
//         getImageHeight(feed[i].media?[0], i, screenWidth);
//       }
//     }
//     id = feed[feed.length - 1].id;
//     update(['posts']);
//   }
//
//   Future<void> getFeedPosts(double screenWidth) async {
//     feed.clear();
//     var posts = await Posts.getFeedPosts(token, feed.length, null) ?? [];
//     for (var i in posts) {
//       bool duplicate = false;
//       var model = await dataToModel(i);
//       for (var j in feed) {
//         if (j.id == model.id) {
//           duplicate = true;
//           break;
//         }
//       }
//       if (!duplicate) {
//         feed.add(model);
//       }
//     }
//     if (posts.isNotEmpty) {
//       for (int i = 0; i < feed.length; i++) {
//         getImageHeight(feed[i].media?[0], i, screenWidth);
//       }
//     }
//     id = feed[feed.length - 1].id;
//     update(['posts']);
//   }
//
//   Future getUsersFeed(double screenWidth, dynamic id) async {
//     accountFeed.value = [];
//     var posts = await Posts.getUserFeedPosts(token, 0, id) ?? [];
//     for (var i in posts) {
//       var model = await dataToModel(i);
//       accountFeed.add(model);
//     }
//     if (posts.isNotEmpty) {
//       for (int i = 0; i < accountFeed.length; i++) {
//         getImageHeight(accountFeed[i].media?[0], i, screenWidth, isAccount: true);
//       }
//     }
//     update(['account-grid']);
//   }
//
//   Future updateUsersFeed(double screenWidth, dynamic id) async {
//     var posts = await Posts.getUserFeedPosts(token, accountFeed.length, id) ?? [];
//     for (var i in posts) {
//       bool duplicate = false;
//       var model = await dataToModel(i);
//       for (var j in accountFeed) {
//         if (j.id == model.id) {
//           duplicate = true;
//           break;
//         }
//       }
//       accountFeed.add(model);
//       if (!duplicate) {
//         accountFeed.add(model);
//       }
//     }
//     if (posts.isNotEmpty) {
//       for (int i = 0; i < accountFeed.length; i++) {
//         getImageHeight(accountFeed[i].media?[0], i, screenWidth, isAccount: true);
//       }
//     }
//     update(['account-grid']);
//   }
//
//   Future<void> getTopPosts(double screenWidth) async {
//     var posts = await Posts.getFeedPosts(token, 0, id) ?? [];
//     for (var i in posts) {
//       bool duplicate = false;
//       var model = await dataToModel(i);
//       for (var j in feed) {
//         if (j.id == model.id) {
//           duplicate = true;
//           break;
//         }
//       }
//       if (!duplicate) {
//         feed.add(model);
//       }
//     }
//     if (posts.isNotEmpty) {
//       for (int i = 0; i < feed.length; i++) {
//         getImageHeight(feed[i].media?[0], i, screenWidth);
//       }
//       update(['posts']);
//     }
//   }
//
//   Future<PostModel> dataToModel(Map data) async {
//     return PostModel(
//       id: data['id'],
//       createdAt: data['created_at'],
//       liked: data['liked'],
//       text: data['text'],
//       url: data['url'],
//       media: data['media'],
//       user: data['user'],
//       comments: data['comments'],
//       likes: data['likes'],
//       canFollow: (await Posts.getUserData(
//         token,
//         data['user']['nickname'],
//       ))['canFollow'],
//     );
//   }
//
//   void switchPostLike(int index) async {
//     if (feed[index].liked == 0) {
//       feed[index].liked = 1;
//       feed[index].likes?['count']++;
//       update(['like']);
//       update(['likes-bar']);
//       update(['page-view']);
//       Posts.like(feed[index].id, token);
//     } else {
//       feed[index].liked = 0;
//       feed[index].likes?['count']--;
//       update(['like']);
//       update(['likes-bar']);
//       update(['page-view']);
//       Map mySelfData = await Posts.getSelfData(token);
//       for (var i in feed[index].likes?['users']) {
//         if (i['nickname'] == mySelfData['nickname']) {
//           feed[index].likes?['users'].remove(i);
//           break;
//         }
//       }
//       Posts.dislike(feed[index].id, token);
//     }
//   }
//
//   void addComment(int index, String text) async {
//     print(4);
//     dynamic value = await Posts.comment(token, feed[index].id, text);
//     if (value != null) {
//       feed[index].comments?['data'].insert(0, value);
//       feed[index].comments?['count']++;
//     }
//     update(['comments', 'show-comments']);
//   }
//
//   void getSelfData() async {
//     mySelfData = await Posts.getSelfData(token);
//     update(['self-avatar']);
//   }
//
//   Future<Map> getUserData(String nickname) async {
//     return Posts.getUserData(token, nickname);
//   }
//
//   void removeComment(int commentId) {}
//
//   void getNewComments(int index) async {
//     if (feed[index].comments?['data'] == null) {
//       feed[index].comments?['data'] = [];
//     }
//     dynamic value = await Posts.getNewComments(
//         token, feed[index].id, feed[index].comments?['data'].length);
//     if (value != null) {
//       for (var i in value) {
//         if (!feed[index].comments?['data'].contains(i)) {
//           feed[index].comments?['data'].add(i);
//         }
//       }
//     }
//     update(['comments']);
//   }
//
//   void getNewLikes(int index, {bool restart = false}) async {
//     if (feed[index].likes?['users'].length == 1 ||
//         feed[index].likes?['users'] == null || restart) {
//       feed[index].likes?['users'] = [];
//     }
//     dynamic value = await Posts.getNewLikes(
//         token, feed[index].id, feed[index].likes?['users'].length);
//     if (value != null) {
//       for (var i in value) {
//         if (!feed[index].likes?['users'].contains(i)) {
//           feed[index].likes?['users'].add(i);
//         }
//       }
//     }
//     update(['likes']);
//   }
//
//   Future<void> getImageHeight(
//       String imageUrl, index, double screenWidth, {bool isAccount = false}) async {
//     Image image = Image.network(imageUrl);
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener(
//         (ImageInfo info, bool isSync) {
//           (isAccount ? accountFeed :feed)[index].imgHeight =
//               info.image.height * (screenWidth / info.image.width);
//           if ((isAccount ? accountFeed :feed)[index].imgHeight != null && (isAccount ? accountFeed :feed)[index].imgHeight!.isNaN) {
//             (isAccount ? accountFeed :feed)[index].imgHeight = null;
//           }
//           if ((isAccount ? accountFeed :feed)[index].imgHeight != null) {
//             update(['page-view']);
//           }
//         },
//       ),
//     );
//   }
//
//   Future<void> followAccount(dynamic id) async {
//     Posts.follow(token, id);
//   }
//
//   Future<void> unfollowAccount(dynamic id) async {
//     Posts.unfollow(token, id);
//   }
// }
