import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/search_screen/widgets/search_field.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final Widget? action;
  final int? navId;
  final Function()? onBack;
  final String search;
  final TabController controller;

  const SearchAppBar(this.controller,
      {this.title = 'грустнограм',
      this.leading = false,
      this.action,
      this.navId,
      this.onBack,
      this.search = '',
      Key? key})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(149.5.w);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: PjColors.background,
      titleSpacing: 0,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leading) ...[
                GestureDetector(
                  onTap: () {
                    if (onBack != null) {
                      onBack!();
                    }
                    Get.back(id: navId);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: SvgPicture.asset(
                    PjIcons.arrowLeft,
                    width: 30.w,
                    height: 30.w,
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: 12.w,
                ),
              ],
              if (leading) ...[
                Text(
                  title,
                  style: TextStyles.interMedium24.copyWith(height: 0.95),
                ),
              ] else
                SizedBox(height: 24.w, width: 148.w, child: SvgPicture.asset(PjIcons.app_logo)),
            ],
          ),
          if (action != null) action!,
        ],
      ),
      bottom: PreferredSize(
          child: Column(
            children: [
              Container(
                color: PjColors.lightGrey,
                height: 1.0.w,
              ),
              SearchField(
                search: search,
              ),
              Theme(
                data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                child: TabBar(
                  isScrollable: true,
                  controller: controller,
                  labelStyle: TextStyles.interRegular14,
                  unselectedLabelColor: const Color(0xFF808080),
                  labelColor: const Color(0xFFFFFFFF),
                  indicator: const UnderlineTabIndicator(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  tabs: const [
                    Tab(text: "аккаунты"),
                    Tab(text: "публикации"),
                  ],
                ),
              ),
            ],
          ),
          preferredSize: Size.fromHeight(200.0.w)),
    );
  }
}
