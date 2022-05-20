import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/controllers/rx_profile_reload.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/favorite_button.dart';
import 'package:gg_copy/project_widgets/follow_button.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:gg_copy/screens/user_list_screen/cubit/cb_user_list_screen.dart';

class UserLabel extends StatefulWidget {
  SelfModel user;
  final String request;
  final bool isShowFavorite;

  UserLabel({Key? key, required this.user, required this.request, this.isShowFavorite = false}) : super(key: key);

  @override
  State<UserLabel> createState() => _UserLabelState();
}

class _UserLabelState extends State<UserLabel> {
  double profileSize = 48.w;
  RxProfileReload profileReload = Get.find(tag: "reload");

  @override
  void initState() {
    log(widget.user.canFollow.toString(), name: "CANFALLOW В ЛЕЙБЛЕ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (SgUser.instance.user.nickname == widget.user.nickname!) {
          navigateToNav(initIndex: 4);
          return;
        }
        Get.to(() => ProfileScreenProvider(nickname: widget.user.nickname!), transition: tr.Transition.cupertino)
            ?.then((value) {
          BlocProvider.of<CbUserListScreen>(context).getData(widget.request);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          height: 48.w,
          width: Get.width - 24.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.user.avatar!,
                    imageBuilder: (context, pro) => Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: pro, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, str) => Container(
                      width: profileSize,
                      height: profileSize,
                      child: SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        child: Text(
                          widget.user.nickname!,
                          style: TextStyles.interMedium14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Container(
                        width: 140.w,
                        child: Text(
                          widget.user.name ?? "",
                          style: TextStyles.interRegular14_808080,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              if(widget.user.id != SgUser.instance.user.id)
              FollowButton(
                  fLabel: "Подписаться",
                  unLabel: "Отменить",
                  isFollow: widget.user.canFollow == 1,
                  onPressed: () {
                    widget.user.canFollow == 1 ? follow() : unFollow();
                  }),
              
              if(widget.isShowFavorite && widget.user.canFollow == 0)
              Container(
                padding: EdgeInsets.only(left: 9.w),
                child: FavoriteButton(state: widget.user.best == 1, onPress: () {
                    if (widget.user.best == 1) {
                        unfavorite();
                    } else {
                        favorite();
                    }
                },),
              )
            ],
          ),
        ),
      ),
    );
  }

  void follow() async {
    bool res = await BlocProvider.of<CbUserListScreen>(context).follow(widget.user.id.toString());
    setState(() {
      widget.user.canFollow = res ? 0 : 1;
    });
  }

  void unFollow() async {
    bool res = await BlocProvider.of<CbUserListScreen>(context).unfollow(widget.user.id.toString());
    setState(() {
      widget.user.canFollow = res ? 1 : 0;
    });
  }

  void favorite() {
    // Сделано для моментального применения в интерфейсе
    setState(() {
      widget.user.best = 1;
    });
    
    BlocProvider.of<CbUserListScreen>(context).favorite(widget.user.id.toString());
  }

  void unfavorite() {
    // Сделано для моментального применения в интерфейсе
    setState(() {
      widget.user.best = 0;
    });

    BlocProvider.of<CbUserListScreen>(context).unfavorite(widget.user.id.toString());
  }
}
