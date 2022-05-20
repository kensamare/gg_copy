import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/project_utils/controllers/rx_profile_reload.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_widgets/pj_button.dart';
import 'package:gg_copy/screens/edit_profile_screen/edit_profile_screen_provider.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/cubit/cb_profile_screen.dart';
import 'package:gg_copy/screens/profile_screen/widgets/counter.dart';
import 'package:gg_copy/screens/user_list_screen/user_list_screen_provider.dart';
import '../../../models/self_model.dart';
import '../../../project_utils/text_styles.dart';

class HeaderProfile extends StatefulWidget {
  final SelfModel user;
  final bool isSelf;
  final String tag;
  final String nickname;
  final int offset;
  final PostController postController;
  final bool isReorderPostsMode;
  final void Function(bool)? onReorderModeChange;

  const HeaderProfile({
    Key? key,
    required this.user,
    required this.isSelf,
    required this.tag,
    required this.nickname,
    required this.postController,
    required this.offset,
    this.onReorderModeChange,
    required this.isReorderPostsMode,
  }) : super(key: key);

  @override
  State<HeaderProfile> createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {

  late RxProfileReload profileReload;
  late bool isSelf;
  bool? isClosedEdit = false;

  @override
  void initState() {
    log(widget.tag.toString(), name: "TAGHEAD");
    profileReload = Get.find(tag: "reload");
    isSelf = widget.isSelf;
    log(widget.user.canFollow.toString(), name: "CANFALOW В ПРОФИЛЕ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: g.Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 28.w,
          ),
          widget.user.avatar == null
              ? Container(
                  width: 100.0.w,
                  height: 100.0.w,
                  child: SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: widget.user.avatar!,
                  imageBuilder: (context, pro) => Container(
                    width: 100.0.w,
                    height: 100.0.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: pro, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, str) => Container(
                    width: 100.0.w,
                    height: 100.0.w,
                    child: SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
          SizedBox(
            height: 14.w,
          ),
          Text(
            '@${widget.user.nickname!}',
            style: TextStyles.interMedium30,
          ),
          if (widget.user.name!.isNotEmpty || widget.user.about!.isNotEmpty)
            SizedBox(
              height: 14.w,
            ),
          if (widget.user.name!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                widget.user.name ?? "",
                style: TextStyles.interMedium16,
                textAlign: TextAlign.center,
              ),
            ),
          if (widget.user.name!.isNotEmpty && widget.user.about!.isNotEmpty)
            SizedBox(
              height: 6.w,
            ),
          if (widget.user.about!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                widget.user.about ?? "",
                style: TextStyles.interRegular14,
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          isSelf
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      PjButton(
                        width: Get.width - (86).w,
                        padding: 0,
                        label: "Редактировать профиль",
                        onPresser: () async {
                          isClosedEdit = await Get.to(
                            () => EditProfileScreenProvider(model: widget.user),
                            transition: tr.Transition.cupertino,
                            duration: const Duration(milliseconds: 700),
                          );
                          if (isClosedEdit == true) {
                            BlocProvider.of<CbProfileScreen>(context).getData(
                                widget.nickname,
                                widget.nickname == "self",
                                widget.offset,
                                updateHeader: true);
                          }
                        },
                        color: PjColors.lightGrey,
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () => widget.onReorderModeChange
                            ?.call(!widget.isReorderPostsMode),
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 46.w,
                          height: 46.w,
                          decoration: BoxDecoration(
                            color: widget.isReorderPostsMode
                                ? PjColors.grey3
                                : PjColors.black3,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              widget.isReorderPostsMode
                                  ? PjIcons.checkBox
                                  : PjIcons.reorderPosts,
                              color: Colors.white,
                              width: widget.isReorderPostsMode ? 20.w : 24.w,
                              height: widget.isReorderPostsMode ? 14.w : 24.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : g.GetBuilder<PostController>(
                  init: widget.postController,
                  id: 'follow',
                  global: false,
                  builder: (_) => _.user.blocked == 1 ? PjButton(
                    label: "Разблокировать",
                    onPresser: () {
                      BlocProvider.of<CbProfileScreen>(context).unBloc();
                    },
                    padding: 32,
                  ) : _.user.canFollow == 1
                      ? PjButton(
                          label: "Подписаться",
                          onPresser: () {
                            _.follow(-1, (e) => null);
                            // bool res =
                            //     await BlocProvider.of<CbProfileScreen>(context)
                            //         .follow(widget.user.id.toString());
                            // profileReload.setReload(true);
                            // if (res == true) {}
                          },
                          padding: 32,
                        )
                      : PjButton(
                          label: "Отписаться",
                          onPresser: () async {
                            _.unfollow(_.user.id!, (e) => null);
                            // bool res =
                            //     await BlocProvider.of<CbProfileScreen>(context)
                            //         .unfollow(widget.user.id.toString());
                            // if (res) {
                            //   profileReload.setReload(true);
                            // }
                          },
                          padding: 32,
                          color: PjColors.background,
                        ),
                ),
          if(widget.user.blocked != 1)...[
            SizedBox(
              height: 30.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 51.w),
              child: g.GetBuilder<PostController>(
                  init: widget.postController,
                  id: 'follow',
                  global: false,
                  builder: (_) {
                    print(_.user.toString());
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Counter(
                          label: "Публикации",
                          count: widget.user.posts ?? 0,
                          open: () {},
                        ),
                        Counter(
                            label: "Подписки",
                            count: _.user.follow ?? 0,
                            open: () => g.Get.to(
                                    () => UserListScreenProvider(id: widget.user.id.toString(), isFollowers: false),
                                transition: g.Transition.cupertino)
                                ?.then((v) {
                              BlocProvider.of<CbProfileScreen>(context)
                                  .getData(widget.nickname, widget.nickname == "self", widget.offset, updateHeader: true);
                            })),
                        Counter(
                            label: "Подписчики",
                            count: _.user.followers ?? 0,
                            open: () => g.Get.to(
                                    () => UserListScreenProvider(id: widget.user.id.toString(), isFollowers: true),
                                transition: g.Transition.cupertino)
                                ?.then((v) {
                              BlocProvider.of<CbProfileScreen>(context)
                                  .getData(widget.nickname, widget.nickname == "self", widget.offset, updateHeader: true);
                            })),
                      ],
                    );
                  }),
            ),
          ],
        ],
      ),
    );
  }
}
