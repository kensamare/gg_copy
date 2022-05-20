import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../project_utils/pj_colors.dart';
import '../project_utils/text_styles.dart';


class FollowButton extends StatefulWidget {
  bool isFollow;
  Function() onPressed;
  String fLabel;
  String unLabel;
   FollowButton({Key? key, required this.isFollow,
     required this.onPressed,
      this.fLabel = "Подписаться",
    this.unLabel = "Отменить"}) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 28.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0.w)),
          border: Border.all(
            color: widget.isFollow ? Colors.transparent : Color(0xFF262626),
          )),
      child: CupertinoButton(
        color: widget.isFollow
            ? PjColors.lightGrey
            : Colors.transparent,
        padding: EdgeInsets.zero,
        child: Text(
          widget.isFollow ? 'Подписаться' : 'Отписаться',
          style: TextStyles.interRegular12,
        ),
        onPressed: widget.onPressed
      ),
    );
  }
}
