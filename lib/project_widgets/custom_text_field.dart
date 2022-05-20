import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';

import '../project_utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.hintText,
    this.obscure = false,
    this.controller,
    this.maxLine = 1,
    this.minLine = 1,
    required this.errorIcon,
    this.enabled = true,
    this.arrowIcon = false,
    this.focusNode,
    this.onEditingComplete,
    this.height = 48.0,
    this.contentPaddingVertical = 0.0,
    this.expands = false,
    this.textAlignVertical,
  }) : super(key: key);

  final String hintText;
  final bool obscure;
  final bool arrowIcon;
  final bool enabled;
  final int? minLine;
  final int? maxLine;
  final TextEditingController? controller;
  bool errorIcon;
  FocusNode? focusNode;
  Function()? onEditingComplete;
  double height;
  double contentPaddingVertical;
  bool expands;
  TextAlignVertical? textAlignVertical;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: TextField(
          onEditingComplete: onEditingComplete,
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          expands: expands,
          textAlignVertical: textAlignVertical,
          minLines: minLine,
          maxLines: maxLine,
          cursorColor: Colors.grey,
          style: TextStyles.interRegular14,
          decoration: InputDecoration(
              suffixIcon: errorIcon
                  ? Container(
                      child: SvgPicture.asset(PjIcons.validate),
                      margin: EdgeInsets.only(right: 15.w),
                    )
                  : (arrowIcon
                      ? Container(
                          child: SvgPicture.asset(PjIcons.arrowRight),
                          margin: EdgeInsets.only(right: 15.w),
                        )
                      : SizedBox()),
              prefixIconConstraints:
                  BoxConstraints(minHeight: 22.w, minWidth: 22.w),
              filled: true,
              hintText: hintText,
              hintStyle: TextStyles.interRegular14_808080,
              fillColor: Theme.of(context).hintColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: contentPaddingVertical),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                borderSide: BorderSide.none,
              )),
        ),
      ),
    );
  }
}
