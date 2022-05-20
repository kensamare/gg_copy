import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/models/user_model.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/screens/liked_screen/widgets/user_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../project_widgets/error_widget.dart';
import '../../project_widgets/pj_appbar.dart';
import '../feed_screen/controllers/post_controller.dart';
import '../user_list_screen/widgets/user_label.dart';
import 'cubit/cb_liked_screen.dart';
import 'cubit/st_liked_screen.dart';

class LikedScreen extends StatefulWidget {
  final int index;
  final String tag;

  LikedScreen({Key? key, required this.index, required this.tag}) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  late PostController _postController;

  late int id;
  late int offset;


  RefreshController _refreshController =
  RefreshController(initialRefresh: false);


  void _onLoading() async {
    await BlocProvider.of<CbLikedScreen>(context).getLiked(id, offset);
    offset += 11;
    _refreshController.loadComplete();
  }


  @override
  void initState() {
    _postController = Get.find(tag: widget.tag);
    id = _postController.posts[widget.index].id!;
    offset = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PjAppBar(
          leading: true,
          title: "Грустят",
        ),
        body: BlocBuilder<CbLikedScreen, StLikedScreen>(
          builder: (context, state) {
            if (state is StLikedScreenLoading) {
              BlocProvider.of<CbLikedScreen>(context).getLiked(id, offset);
              offset += 11;
              return const Center(
                child: Loader(),
              );
            }
            if (state is StLikedScreenLoaded) {
              return SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: false,
                  controller: _refreshController,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      if (mode == LoadStatus.loading) {
                        return Container(
                          height: 55.0.w,
                          child: Center(child: Loader()),
                        );
                      }
                      return Container();
                    },
                  ),
                  onLoading: _onLoading,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 24.w),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) => UserCard(
                      user: state.users[index],
                    ),
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 20.w,
                      );
                    },
                  ));
            }
            if (state is StLikedScreenError) {
              return ErrWidget(
                errorCode: state.error.toString(),
                callback: () {
                  Get.back();
                },
              );
            }
            return Container(color: Colors.grey);
          },
        ));
  }
}
