import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class CupertinoAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final Function() onBack;
  final Function() onSave;

  const CupertinoAppBar(
      {this.title = 'грустнограм', required this.onBack, required this.onSave, Key? key})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onBack,
            child: Container(
              padding: EdgeInsets.only(left: 12.w, right: 32.w),
              height: 40.w,
              child: Center(child: Text("Отмена", style: TextStyles.interMedium14_b8)),
            ),
          ),
          Center(
            child: Text(title, style: TextStyles.interMedium16,),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onSave,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              height: 40.w,
              child: Center(child: Text("Сохранить", style: TextStyles.interMedium14_b8)),
            ),
          ),

        ],
      ),
      bottom: PreferredSize(
          child: Container(
            color: PjColors.lightGrey,
            height: 1.0.w,
          ),
          preferredSize: Size.fromHeight(1.0.w)),
    );
  }
}
