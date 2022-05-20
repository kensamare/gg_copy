import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class SuccessSheetContent extends StatelessWidget {
  final String text;

  const SuccessSheetContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.w,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 26.w,
                ),
                SvgPicture.asset(
                  PjIcons.appleid,
                  width: 44.w,
                  height: 44.w,
                ),
                SizedBox(
                  height: 26.w,
                ),
                SizedBox(
                  width: 224.w,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyles.interMedium16_808080,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
