import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class TextIconToggle extends StatelessWidget {
  final IconData? icon;
  final String text;
  final TextIconToggleState state;
  final bool isShowBadge;

  final void Function(TextIconToggleState) stateChanged;

  const TextIconToggle(
      {Key? key,
      required this.text,
      required this.icon,
      required this.stateChanged,
      required this.isShowBadge,
      this.state = TextIconToggleState.unselected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var newState = TextIconToggleState.unselected;

        if (state == TextIconToggleState.unselected) {
          newState = TextIconToggleState.selectedText;
        } else if (state == TextIconToggleState.selectedText) {
          newState = TextIconToggleState.selectedIcon;
        } else if (state == TextIconToggleState.selectedIcon) {
          newState = TextIconToggleState.selectedText;
        }

        stateChanged(newState);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: state == TextIconToggleState.unselected ? 29.w : 30.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23.w),
            border: Border.all(color: PjColors.lightGrey, width: 1.w)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              fit: StackFit.passthrough,
              alignment: Alignment.centerRight,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  decoration: BoxDecoration(
                      color: state == TextIconToggleState.selectedText
                          ? PjColors.grey3
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(28)),
                  child: Center(
                      child: Row(children: [
                    Text(text,
                        style:
                            TextStyles.interRegular14.copyWith(height: 0.95.w))
                  ])),
                ),
                if (isShowBadge) ...[
                  Positioned(
                    right: 2.w,
                    child: Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        color: PjColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )
                ]
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                  child: Icon(icon),
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: state == TextIconToggleState.selectedIcon
                          ? PjColors.grey3
                          : PjColors.black2)),
            ),
          ],
        ),
      ),
    );
  }
}

enum TextIconToggleState { selectedIcon, selectedText, unselected }
