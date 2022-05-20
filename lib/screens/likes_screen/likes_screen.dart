import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gg_copy/models/notifications_model.dart';
import 'package:gg_copy/project_utils/controllers/rx_badges.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen.dart';
import 'package:gg_copy/screens/comment_screen/comment_screen_provider.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../project_utils/time_conventer.dart';
import '../../project_widgets/error_widget.dart';
import '../../project_widgets/loader.dart';
import '../comment_from_notifications_screen/comment_from_notifications_screen_provider.dart';
import 'cubit/cb_likes_screen.dart';
import 'cubit/st_likes_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<NotificationsModel> result = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await BlocProvider.of<CbLikesScreen>(context).getData();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    try{
      FlutterAppBadger.removeBadge();
    } catch(e){
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PjAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: BlocBuilder<CbLikesScreen, StLikesScreen>(
          builder: (context, state) {
            if (state is StLikesScreenLoading) {
              BlocProvider.of<CbLikesScreen>(context).getData();
              return const Center(
                child: Loader(),
              );
            }
            if (state is StLikesScreenLoaded) {
              result = state.result;
              return Column(
                children: [
                  SizedBox(height: 26.w),
                  Text(
                    'события',
                    style: TextStyles.interSemiBold14,
                  ),
                  SizedBox(height: 32.w),
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      header: CustomHeader(
                        builder: (BuildContext context, RefreshStatus? mode) {
                          return Container(
                            child: Center(
                                child: Lottie.asset('assets/images/loader.json',
                                    width: 50.w)),
                          );
                        },
                      ),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemCount: result.length,
                          itemBuilder: (BuildContext context, int index) {
                            String time = getTime(result[index].createdAt!);
                            String title = '';
                            String dopTitle = '';
                            switch (result[index].type) {
                              case 'follow':
                                title = 'Теперь грустит с вами ';
                                dopTitle = 'вместе с вами ';
                                break;
                              case 'like':
                                title = 'Разбил(-а) сердце ';
                                break;
                              case 'link':
                                title = 'Погрустил(-а) о вас ';
                                dopTitle = result[index].data!.text!.length > 55
                                    ? "${result[index].data!.text!.substring(0, 55)}... "
                                    : result[index].data!.text! + " ";
                                break;
                              case 'comment':
                                title = 'Комментирует ';
                                dopTitle = result[index].data!.text!.length > 55
                                    ? "${result[index].data!.text!.substring(0, 55)}... "
                                    : result[index].data!.text! + " ";
                            }
                            return Column(
                              children: [
                                SizedBox(
                                  height: 63.w,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(result[index].data!.avatar != null
                                              ? result[index].data!.avatar!
                                              : "https://560621.selcdn.ru/gg/empty_profile.jpg"),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (BuildContext context) {
                                                return ProfileScreenProvider(nickname: result[index].data!.nickname!);
                                              },
                                            ),
                                          );
                                        },
                                        behavior: HitTestBehavior.translucent,
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (BuildContext context) {
                                                    return ProfileScreenProvider(nickname: result[index].data!.nickname!);
                                                  },
                                                ),
                                              );
                                            },
                                            child: Text(
                                              result[index].data!.nickname!,
                                              style: TextStyles.interMedium14,
                                            ),
                                          ),
                                          Container(
                                            width: 250.w,
                                            child: RichText(
                                              text: TextSpan(
                                                // text: result[index].type == 'like'
                                                //     ? 'Грустит '
                                                //     : result[index].type ==
                                                //             'comment'
                                                //         ? 'Комментирует '
                                                //         : 'Подписался(-ась) на вас ',
                                                text: title,
                                                style: DefaultTextStyle.of(context).style,
                                                children: <TextSpan>[
                                                  if (result[index].type != 'follow') ...[
                                                    TextSpan(
                                                        text: dopTitle,
                                                        // text:
                                                        //     result[index].type ==
                                                        //             'like'
                                                        //         ? 'вместе с вами '
                                                        //         : result[index].data!.text!.length > 55 ? "${result[index].data!.text!.substring(0, 55)}... " : result[index].data!.text! + " ",
                                                        style: TextStyles.interRegular12o70),
                                                  ],
                                                  TextSpan(text: time, style: TextStyles.interRegular12_808080),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      if (result[index].type != 'follow') ...[
                                        GestureDetector(
                                          child: Container(
                                            height: 38.w,
                                            width: 38.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Image.network(result[index].data!.postImg!),
                                          ),
                                          onTap: () async {
                                            var res = await Get.to(() => CommentFromNotificationsScreenProvider(
                                                  url: result[index].data!.postUrl!,
                                                  index: result[index].idPost!,
                                                ));
                                            // Navigator.of(context).push(
                                            //   CupertinoPageRoute(
                                            //     builder: (BuildContext context) {
                                            //       return CommentScreenProvider(
                                            //           index: state
                                            //               .result[index].idPost!);
                                            //     },
                                            //   ),
                                            // );
                                          },
                                          behavior: HitTestBehavior.translucent,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.w),
                              ],
                            );
                          }),
                    ),
                  )
                ],
              );
            }
            if (state is StLikesScreenError) {
              return ErrWidget(
                errorCode: state.error.toString(),
                callback: () {
                  BlocProvider.of<CbLikesScreen>(context).getData();
                },
              );
            }
            return Container(color: Colors.grey);
          },
        ),
      ),
    );
  }
}
