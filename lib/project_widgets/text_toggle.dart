import 'package:flutter/material.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class TextToggle extends StatelessWidget {
  final bool isSelected;
  final Function(bool) onToggle;
  final String text;
  final bool isShowBadge;

  const TextToggle(
      {Key? key,
      required this.text,
      required this.isSelected,
      required this.onToggle,
      this.isShowBadge = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle(!isSelected);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: isSelected ? 29.h : 30.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
            color: isSelected ? PjColors.grey3 : PjColors.background,
            borderRadius: BorderRadius.circular(23.w),
            border: Border.all(color: PjColors.lightGrey, width: 1.w)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text,
                style: TextStyles.interRegular14.copyWith(height: 0.95.w)),
            if (isShowBadge) ...[
              SizedBox(
                width: 5.w,
              ),
              Container(
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: PjColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
