import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gg_copy/project_utils/controllers/rx_profile_edit.dart';
import 'package:gg_copy/project_utils/controllers/rx_profile_reload.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/user_list_screen/widgets/user_label.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'cubit/cb_user_list_screen.dart';
import 'cubit/st_user_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatefulWidget {
  final bool isFollowers;
  final String id;

  UserListScreen({Key? key, required this.id, required this.isFollowers})
      : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    BlocProvider.of<CbUserListScreen>(context).getData(
        widget.isFollowers
            ? "followers/${widget.id}"
            : "follow/${widget.id}");
    _refreshController.refreshCompleted();
  }

  RxProfileReload reloadProfile = Get.find(tag: "reload");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PjAppBar(
        leading: true,
        title: widget.isFollowers ? "подписчики" : "подписки",
      ),
      backgroundColor: PjColors.background,
      body: BlocBuilder<CbUserListScreen, StUserListScreen>(
        builder: (context, state) {
          if (state is StUserListScreenLoading) {
            BlocProvider.of<CbUserListScreen>(context).onReload(  widget.isFollowers
                ? "followers/${widget.id}"
                : "follow/${widget.id}");
            BlocProvider.of<CbUserListScreen>(context).getData(
                widget.isFollowers
                    ? "followers/${widget.id}"
                    : "follow/${widget.id}");
            return const Center(
              child: Loader(),
            );
          }
          if (state is StUserListScreenLoaded) {

            return SmartRefresher(
              enablePullUp: false,
              enablePullDown: true,
              onRefresh: _onRefresh,
              controller: _refreshController,
              header: CustomHeader(
                builder: (BuildContext context, RefreshStatus? mode) {
                  return SizedBox(
                      height: 55.0.w,
                      child: const Loader(),
                    );
                },
              ),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.w),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: state.users.length,
                itemBuilder: (context, index) => UserLabel(
                  user: state.users[index],
                  request: widget.isFollowers
                      ? "followers/${widget.id}"
                      : "follow/${widget.id}", 
                  isShowFavorite: widget.isFollowers == false,
                ),
                separatorBuilder: (context, i) {
                  return SizedBox(
                    height: 20.w,
                  );
                },
              ),
            );
          }
          if (state is StUserListScreenError) {
            return ErrWidget(errorCode: state.error.toString(),);
          }
          return Container(color: Colors.grey);
        },
      ),
    );
  }
}
