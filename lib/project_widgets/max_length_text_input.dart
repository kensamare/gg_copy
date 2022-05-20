import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/text_styles.dart';

class MaxLengthTextInput extends StatefulWidget {
  int? maxLength;
  String? placeholder;
  void Function(String text)? onChange;

  MaxLengthTextInput(
      {Key? key, this.maxLength, this.placeholder, this.onChange})
      : super(key: key);

  @override
  State<MaxLengthTextInput> createState() => _MaxLengthTextInputState();
}

class _MaxLengthTextInputState extends State<MaxLengthTextInput> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 16.w, bottom: 10.w, left: 14.w, right: 14.w),
      child: Container(
        decoration: BoxDecoration(
          color: PjColors.black2,
          borderRadius: BorderRadius.circular(
            10.0.w,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              child: TextField(
            cursorColor: Colors.grey,
            style: TextStyles.interRegular14,
            maxLines: 7,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (t) {
              setState(() {
                text = t;
                if (widget.onChange != null) {
                  widget.onChange!(t);
                }
              });
            },
            decoration: InputDecoration(
              filled: true,
              hintText: widget.placeholder,
              hintStyle: TextStyles.interRegular14_808080,
              isCollapsed: true,
              fillColor: Colors.transparent,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.only(
                  left: 14.w,
                  right: 14.w,
                  top: 12.0.w,
                  bottom: widget.maxLength == null ? 12.h : 8.h),
            ),
          )),
          if (widget.maxLength != null)
            Padding(
              padding: EdgeInsets.only(left: 14.w, bottom: 16.w),
              child: Text(
                "${text.length} / ${widget.maxLength}",
                style: TextStyles.interRegular12grey3,
              ),
            ),
        ]),
      ),
    );
  }
}
