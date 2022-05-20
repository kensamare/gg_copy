import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_follows.dart';

import '../../../models/self_model.dart';
import '../../../project_utils/controllers/rx_profile_reload.dart';
import '../../../project_utils/pj_icons.dart';
import '../../../project_utils/singletons/sg_user.dart';
import '../../../project_utils/text_styles.dart';
import '../../../project_widgets/follow_button.dart';
import '../../profile_screen/profile_screen_provider.dart';
import '../cubit/cb_liked_screen.dart';

class UserCard extends StatefulWidget {
  SelfModel user;

  UserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  double profileSize = 48.w;
  RxProfileReload profileReload = Get.find(tag: "reload");
  @override
  void initState() {
    print(widget.user.nickname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (SgUser.instance.user.nickname == widget.user.nickname!) {
          navigateToNav(initIndex: 4);
          // Get.offAll(() => NavigationScreen(
          //   init: 4,
          // ));
          return;
        }
        Get.to(ProfileScreenProvider(nickname: widget.user.nickname!),
            transition: tr.Transition.cupertino);
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
                      child:
                      SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
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
                      Text(
                        widget.user.nickname!,
                        style: TextStyles.interMedium14,
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
              Visibility(
                visible: widget.user.nickname != SgUser.instance.user.nickname,
                child: FollowButton(
                    fLabel: "Подписаться",
                    unLabel: "Отменить",
                    isFollow: widget.user.canFollow == 1,
                    onPressed: () {
                      widget.user.canFollow == 1 ? follow() : unFollow();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void follow() async {
    bool res = await BlocProvider.of<CbLikedScreen>(context)
        .follow(widget.user.id.toString());
    profileReload.setReload(true);
    setState(() {
      widget.user.canFollow = res ? 0 : 1;
      SgFollows.instance.follows.add(widget.user.nickname!);
      if(SgFollows.instance.unfollows.contains(widget.user.nickname!)){
        SgFollows.instance.unfollows.remove(widget.user.nickname!);
      }
    });
  }

  void unFollow() async {
    bool res = await BlocProvider.of<CbLikedScreen>(context)
        .unfollow(widget.user.id.toString());
    profileReload.setReload(true);
    setState(() {
      widget.user.canFollow = res ? 1 : 0;
      SgFollows.instance.unfollows.add(widget.user.nickname!);
      if(SgFollows.instance.follows.contains(widget.user.nickname!)){
        SgFollows.instance.follows.remove(widget.user.nickname!);
      }
    });

  }
}
