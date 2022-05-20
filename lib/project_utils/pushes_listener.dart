import 'package:eticon_api/eticon_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_type.dart';
import 'package:gg_copy/screens/posts_page_builder_screen/posts_page_builder_screen.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';

class PushsesListener {
  static void listen() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (Api.tokenIsNotEmpty()) {
        if (event.data['type'] == 'newposts') {
          __handleNewPosts();
          return;
        }
        if (event.data['type'] != 'follow') {
          Get.to(() => CommentFromNotificationsScreenProvider(
                index: 0,
                url: event.data['url'],
                notification: true,
              ));
        } else {
          Get.to(() => ProfileScreenProvider(nickname: event.data['nickname']));
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        if (Api.tokenIsNotEmpty()) {
          if (event.data['type'] == 'newposts') {
            __handleNewPosts();
            return;
          }
          if (event.data['type'] != 'follow') {
            Get.to(() => CommentFromNotificationsScreenProvider(
                  index: 0,
                  url: event.data['url'],
                  notification: true,
                ));
          } else {
            Get.to(
                () => ProfileScreenProvider(nickname: event.data['nickname']));
          }
        }
      }
    });
  }

  static void __handleNewPosts() {
    gSelect = PostTypeValue.myFavorite;
    Get.to(() => NavigationScreen(init: 0));
    return;
  }
}
