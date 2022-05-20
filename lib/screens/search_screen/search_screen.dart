import 'package:cached_network_image/cached_network_image.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_feed_screen.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_appbar.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_feed_screen.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_field.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_post_card.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_user_card.dart';
import '../../project_utils/text_styles.dart';
import '../../project_widgets/error_widget.dart';
import 'cubit/cb_search_screen.dart';
import 'cubit/st_search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class SearchScreen extends StatefulWidget {
  final String search;
  SearchScreen({Key? key, this.search = ''}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    int initIndex = 0;
    if(widget.search.isNotEmpty){
      initIndex = 1;
    }
    tabController = TabController(length: 2, vsync: this, initialIndex: initIndex);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(widget.search.isNotEmpty){
        BlocProvider.of<CbSearchScreen>(context).getData(widget.search.replaceAll('#', '%23'));
      } else{
        BlocProvider.of<CbSearchScreen>(context).getTopData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(tabController, title: 'вернуться', leading: widget.search.isNotEmpty, search: widget.search,),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocBuilder<CbSearchScreen, StSearchScreen>(
          builder: (context, state) {
            if (state is StSearchScreenInit) {
              return TabBarView(
                controller: tabController,
                children: [
                  ListView.separated(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: 24.w),
                    itemBuilder: (context, i) {
                      return SearchUserCard(
                        model: state.users[i],
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 20.w,
                      );
                    },
                    itemCount: state.users.length,
                  ),
                  GridView.count(
                    padding: EdgeInsets.only(top: 20.w),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: [
                      for (int i = 0; i < state.posts.length; i++)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await Get.to(
                                    () => SearchFeedScreen(postModel: state.posts, initIndex: i, isNavBar: false, offset: 0,),
                                // () => CommentScreenProvider(
                                //       index: i,
                                //       isBottomNavigation: false,
                                //       tag: tag,
                                //     ),
                                transition: tr.Transition.cupertino);
                            // if (res is bool) {
                            //   BlocProvider.of<CbProfileScreen>(context)
                            //       .deletePost(i, widget.nickname, widget.nickname == "self", offset);
                            // } else {
                            //   BlocProvider.of<CbProfileScreen>(context)
                            //       .getData(widget.nickname, widget.nickname == "self", offset, updateHeader: true);
                            // }
                          },
                          child: CachedNetworkImage(
                            imageUrl: state.posts[i].media250![0],
                            imageBuilder: (context, pro) =>
                                Container(
                                  width: 123.0.w,
                                  height: 123.0.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: pro, fit: BoxFit.cover),
                                  ),
                                ),
                          ),
                        )
                    ],
                  ),
                  // Container(),
                ],
              );
            }
            if (state is StSearchScreenLoading) {
              return const Center(
                child: Loader(),
              );
            }
            if (state is StSearchScreenLoaded) {
              return TabBarView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: tabController,
                children: [
                  ListView.separated(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: 24.w),
                    itemBuilder: (context, i) {
                      return SearchUserCard(
                        model: state.users[i],
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 20.w,
                      );
                    },
                    itemCount: state.users.length,
                  ),
                  ListView.separated(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: 24.w),
                    itemBuilder: (context, i) {
                      return SearchPostCard(
                        model: state.posts[i],
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 20.w,
                      );
                    },
                    itemCount: state.posts.length,
                  ),
                ],
              );
            }
            if (state is StSearchScreenError) {
              return ErrWidget(
                errorCode: state.error.toString(),
              );
            }
            return Container(color: Colors.grey);
          },
        ),
      ),
    );
  }
}
