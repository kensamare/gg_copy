import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/pj_button.dart';

void showGGBottomSheet(
  BuildContext context,
  Widget Function(BuildContext context) builder,
  String title,
  Widget? Function(BuildContext context) leftItembuilder,
  Widget? Function(BuildContext context) rightItembuilder,
) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      constraints: BoxConstraints(
        minWidth: Get.width,
        minHeight: 150.w,
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(runAlignment: WrapAlignment.end, children: [
            Container(
              width: Get.width,
              height: 42.w,
              decoration: BoxDecoration(
                color: PjColors.black10,
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftItembuilder(context) ?? Container(),
                    Text(
                      title,
                      style: TextStyles.interSemiBold14,
                    ),
                    rightItembuilder(context) ?? Container(),
                  ],
                ),
              ),
            ),
            Container(
              child: builder(context),
              color: PjColors.black3,
            )
          ]),
        );
      });
}
