import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class PjAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final int? userId;
  final Widget? action;
  final TextStyle? textStyle;
  final int? navId;
  final String? nickname;
  final Function()? onBack;
  final bool isNotSelf;
  final Color color;
  final bool bottomLine;
  final bool notBack;

  const PjAppBar(
      {this.bottomLine = true,
      this.color = PjColors.background,
      this.title = 'null',
      this.leading = false,
        this.isNotSelf = false,
      this.action,
      this.navId,
      this.onBack,
      this.notBack = false,
      this.textStyle,
        this.userId,
        this.nickname,
      Key? key})
      : super(key: key);


  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    log(isNotSelf.toString(), name: "ISSELF");
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: color,
      titleSpacing: 0,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (leading) {
                if (onBack != null) {
                  onBack!();
                }
                if (!notBack) {
                  if (navId != null) {
                    Get.back(id: navId);
                  } else {
                    Get.back();
                  }
                }
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                if (leading) ...[
                  SvgPicture.asset(
                    PjIcons.arrowLeft,
                    width: 30.w,
                    height: 30.w,
                  ),
                ] else ...[
                  SizedBox(
                    width: 12.w,
                  ),
                ],
                if (title == 'null') ...[
                  SizedBox(
                    height: 24.w,
                      width: 148.w,
                      child: SvgPicture.asset(PjIcons.app_logo))
                ] else ...[
                  Text(
                    title,
                    style: (textStyle ?? TextStyles.interMedium24)
                        .copyWith(height: 0.95),
                  ),
                ]
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
      bottom: bottomLine
          ? PreferredSize(
              child: Container(
                color: PjColors.lightGrey,
                height: 1.0.w,
              ),
              preferredSize: Size.fromHeight(1.0.w))
          : null,
    );
  }
}
