import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:badges/badges.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gg_copy/project_utils/controllers/rx_badges.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu_avatar.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pushes_listener.dart';
import 'package:gg_copy/project_utils/singletons/sg_nested.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_type.dart';
import 'package:gg_copy/screens/likes_screen/likes_screen_provider.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:gg_copy/screens/post_create_screen/post_create_screen.dart';
import 'package:gg_copy/screens/post_create_screen/post_create_screen_provider.dart';
import 'package:gg_copy/screens/posts_page_builder_screen/posts_page_builder_screen.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:gg_copy/screens/sms_check_screen/sms_check_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:flutter/services.dart';
import '../project_utils/controllers/rx_menu.dart';
import '../project_utils/controllers/rx_profile_reload.dart';
import '../project_utils/controllers/rx_user_id.dart';
import '../project_utils/pj_icons.dart';
import '../project_utils/themes.dart';
import '../project_widgets/error_widget.dart';
import '../screens/search_screen/search_screen_provider.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key) {
    Get.put<RxMenu>(RxMenu(initIndex: 0), tag: "menu", permanent: true);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  RxProfileReload profileReload = Get.put(RxProfileReload(), tag: "reload");
  RxUserId userIdController = Get.put(RxUserId(), tag: "userId");

  @override
  void initState() {
    PushsesListener.listen();
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        builder: (context, widget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!);
        },
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: ThemeMode.dark,
        title: 'Грустнограм',
        debugShowCheckedModeBanner: false,
        home: Api.tokenIsEmpty()
            ? GetStorage().read('phone_key') != null
                ? SmsCheckScreenProvider(
                    phone_key: GetStorage().read('phone_key'))
                : const LoginScreenProvider()
            // :
            : NavigationScreen(
                init: 0,
              ),
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final int init;

  NavigationScreen({Key? key, this.init = 0}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  RxMenuAvatar avatarController = Get.put(RxMenuAvatar(), tag: "menuAvatar");
  RxMenu menuController = Get.find(tag: "menu");
  late RxBadges badgesController;

  //@todo Вставить нормальные страницы

  List<Widget> page = [
    // FeedScreenProvider(),
    SearchScreenProvider(),
    PostCreateScreenProvider(),
    LikesScreenProvider(),
    ProfileScreenProvider(nickname: 'self', isMenu: true)
  ];

  @override
  void initState() {
    badgesController = Get.put(RxBadges(), tag: 'badge');
    badgesController.updateCount();
    // menuController = Get.put<RxMenu>(RxMenu(initIndex: widget.init), tag: "menu", permanent: true);
    menuController.addListener(() {
      if (mounted) {
        if (menuController.currentIndex.value != 0) {
          gSelect = PostTypeValue.warm;
        }
        if (menuController.currentIndex.value == 3) {
          badgesController.count.value = 0;
        }
        print(menuController.currentIndex.value);
      }
    });
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Get.to(() => PostCreateScreenProvider());
    } else {
      menuController.updateIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (menuController.isComment && Platform.isAndroid) {
          Get.back(id: SgNested.instance.id);
          menuController.isComment = false;
        }
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => Container(
            color: !avatarController.comment.value
                ? Theme.of(context).canvasColor
                : Theme.of(context).backgroundColor,
            child: Padding(
              padding: EdgeInsets.only(top: 1.w),
              child: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).backgroundColor,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: PjColors.white,
                  unselectedItemColor: PjColors.white,
                  showSelectedLabels: false,
                  showUnselectedLabels: true,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Obx(
                          () => SvgPicture.asset(
                            menuController.currentIndex.value == 0
                                ? PjIcons.homeAlt
                                : PjIcons.home,
                          ),
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Obx(
                          () => SvgPicture.asset(
                            menuController.currentIndex.value == 1
                                ? PjIcons.searchAlt
                                : PjIcons.search,
                          ),
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Obx(
                          () => SvgPicture.asset(
                            menuController.currentIndex.value == 2
                                ? PjIcons.addAlt
                                : PjIcons.add,
                          ),
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Container(
                          height: 32.w,
                          child: Obx(
                            () => Badge(
                              showBadge: badgesController.count.value == 0
                                  ? false
                                  : true,
                              badgeContent: Text(
                                '${badgesController.count.value > 99 ? '99+' : badgesController.count.value}',
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'PjInter'),
                              ),
                              badgeColor: PjColors.white,
                              child: SvgPicture.asset(
                                menuController.currentIndex.value == 3
                                    ? PjIcons.heartAlt
                                    : PjIcons.heartMenu,
                              ),
                            ),
                          ),
                        ),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            width: 26.w,
                            height: 26.w,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(PjIcons.profile),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                              visible: avatarController.url.value != "",
                              child: SizedBox(
                                width: 26.w,
                                height: 26.w,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(avatarController.url.value),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            );
                          }),
                          Obx(
                            () => Visibility(
                              visible: menuController.currentIndex.value == 4,
                              child: SizedBox(
                                width: 32.w,
                                height: 32.w,
                                child: Image.asset(PjIcons.ochko),
                              ),
                            ),
                          ),
                        ]),
                        label: ""),
                  ],
                  currentIndex: menuController.currentIndex.value,
                  onTap: _onItemTapped,
                  enableFeedback: false,
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          switch (menuController.currentIndex.value) {
            case 0:
              return FeedScreenProvider(
                menuController: menuController,
              );
            case 1:
              return SearchScreenProvider();
            case 2:
              return Container();
            case 3:
              return LikesScreenProvider();
            case 4:
              return ProfileScreenProvider(nickname: 'self', isMenu: true);
          }
          return Container();
          // if(menuController.currentIndex.value == 0){
          //   return FeedScreenProvider();
          // }
          // return page[menuController.currentIndex.value];
        }),
      ),
    );
  }
}

// return
// GetMaterialApp(
//   theme: Themes.lightTheme,
//   darkTheme: Themes.darkTheme,
//   themeMode: ThemeMode.dark,
//   home: LoginScreenProvider(),
// getPages: [
//   GetPage(
//     name: '/feed-page',
//     page: () => const FeedPage(),
//   ),
//   GetPage(
//     name: '/login-page',
//     page: () => LoginPage(),
//   ),
//   GetPage(
//     name: '/account-page',
//     page: () => AccountPage(),
//   ),
//   GetPage(
//     name: '/post-comment-page',
//     page: () => PostCommentPage(),
//   ),
//   GetPage(
//     name: '/posts-likes',
//     page: () => PostLikesPage(),
//   ),
// ],
//   );
// }}

Future<void> navigateToNav({int initIndex = 0}) async {
  if (Get.isRegistered<RxMenu>(tag: "menu")) {
    await Get.delete<RxMenu>(tag: "menu", force: true);
  }
  Get.put<RxMenu>(RxMenu(initIndex: initIndex), tag: "menu", permanent: true);
  SgNested.instance.id = 1; //math.Random().nextInt(1000000);
  Get.offAll(
      () => NavigationScreen(
            init: initIndex,
          ),
      transition: tr.Transition.cupertino);
}
