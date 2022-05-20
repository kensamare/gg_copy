import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';

import '../project_utils/text_styles.dart';

class PjButton extends StatefulWidget {
  Function()? onPresser;
  String label;
  Color color;
  double padding;
  final double? width;

  PjButton({
    required this.label,
    this.onPresser,
    this.color = PjColors.textGrey,
    this.padding = 14,
    this.width,
  });

  @override
  State<PjButton> createState() => _PjButtonState();
}

class _PjButtonState extends State<PjButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding.w),
      child: SizedBox(
        width: widget.width ?? Get.width - widget.padding * 2,
        height: 45.w,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: widget.color == PjColors.background
                ? Border.all(color: PjColors.black1, width: 1.w)
                : null,
          ),
          child: CupertinoButton(
            color: widget.color,
            child: Text(
              widget.label,
              style: TextStyles.interMedium14,
              textAlign: TextAlign.center,
            ),
            onPressed: widget.onPresser,
          ),
        ),
      ),
    );
  }
}
