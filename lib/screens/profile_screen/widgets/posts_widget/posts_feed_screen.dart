import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/models/post_model.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

import '../../../../project_widgets/loader.dart';
import '../../../login_screen/login_screen_provider.dart';
import '../../cubit/cb_profile_screen.dart';

class PostsFeedScreen extends StatefulWidget {
  final List<PostModel> postModel;
  final int index;
  final int idUser;
  final bool isNavBar;
  final PostController profileController;

  const PostsFeedScreen(
      {Key? key,
      required this.postModel,
      required this.idUser,
      required this.index,
      required this.profileController,
      required this.isNavBar})
      : super(key: key);

  @override
  _PostsFeedScreenState createState() => _PostsFeedScreenState();
}

class _PostsFeedScreenState extends State<PostsFeedScreen> {
  PostController postController = Get.put(PostController(), tag: 'profileFeed');
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = ScrollController();
  ItemPositionsListener positionsListener = ItemPositionsListener.create();
  IndicatorController indicatorController = IndicatorController();

  @override
  void initState() {
    super.initState();
    log(widget.index.toString(), name: "index");
    postController.posts = widget.postModel;
    positionsListener.itemPositions.addListener(() {
      var value = positionsListener.itemPositions.value.first.index;
      if (value == widget.postModel.length - 1) {
        refreshController.footerMode!.value = LoadStatus.loading;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = 250.0.w;
    log('TUT');
    return Scaffold(
      appBar: PjAppBar(
        leading: true,
        title: 'вернуться',
        bottomLine: true,
      ),
      body: CustomRefreshIndicator(
        controller: indicatorController,
        reversed: true,
        leadingScrollIndicatorVisible: true,
        trailingScrollIndicatorVisible: false,
        builder: (BuildContext context, Widget child,
            IndicatorController controller) {
          return AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final dy = controller.value.clamp(0.0, 1.25) *
                    -(height - (height * 0.25));
                return Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(0.0, dy),
                      child: child,
                    ),
                    Positioned(
                      bottom: -height,
                      left: 0,
                      right: 0,
                      height: height,
                      child: Container(
                        transform: Matrix4.translationValues(0.0, dy, 0.0),
                        padding: const EdgeInsets.only(top: 30.0),
                        constraints: const BoxConstraints.expand(),
                        child: Column(
                          children: [Center(child: Loader())],
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        onRefresh: () async {
          try {
            Map<String, dynamic> response = await Api.get(
                method: 'posts',
                testMode: true,
                query: {
                  "id_user": widget.idUser,
                  "limit": 15,
                  "offset": widget.profileController.offset
                },
                isAuth: true);
            widget.profileController.offset += 15;
            response["data"].forEach((v) {
              setState(() {
                widget.postModel.add(PostModel.fromJson(v));
                log(widget.postModel.length.toString(), name: "length");
              });
            });
            if (response['data'].isNotEmpty) {
              refreshController.loadComplete();
            }
          } on APIException catch (e) {
            if (e.code == 400) {
              Map<String, dynamic> error = jsonDecode(e.body);
              if (error['err'][0] == 4 || error['err'][0] == 5) {
                Get.offAll(LoginScreenProvider(),
                    transition: tr.Transition.cupertino);
              }
            }
          } on StateError catch (e) {
            log('SKIP');
          }
        },
        child: ScrollablePositionedList.separated(
          itemPositionsListener: positionsListener,
          itemBuilder: (context, index) {
            return Post(
              deleteCallback: (postId) async {
                try {
                  Map<String, dynamic> delete = await Api.delete(
                      method: "posts/${postId ?? widget.postModel[index].id}",
                      isAuth: true);
                  setState(() {
                    widget.postModel.removeAt(index);
                  });
                } on APIException catch (e) {
                  if (e.code == 400) {
                    Map<String, dynamic> error = jsonDecode(e.body);
                    if (error['err'][0] == 4 || error['err'][0] == 5) {
                      Get.offAll(LoginScreenProvider(),
                          transition: tr.Transition.cupertino);
                    }
                  }
                } on StateError catch (e) {
                  log('SKIP');
                }
              },
              index: index,
              commentsCount: widget.postModel[index].comments!.count,
              tag: 'profileFeed',
              profileFeed: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 25.w,
            );
          },
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(
              left: 12.w, top: 14.w, right: 12.w, bottom: 100.w),
          itemCount: widget.postModel.length,
          initialScrollIndex: widget.index,
        ),
      ),
    );
  }
}
