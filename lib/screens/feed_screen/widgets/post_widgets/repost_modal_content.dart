import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/max_length_text_input.dart';
import 'package:gg_copy/project_widgets/pj_button.dart';

class RepostModalContent extends StatefulWidget {
  final Function(BuildContext context, String? comment) onRepostPress;
  const RepostModalContent({Key? key, required this.onRepostPress})
      : super(key: key);

  @override
  State<RepostModalContent> createState() => _RepostModalContentState();
}

class _RepostModalContentState extends State<RepostModalContent> {
  int maxLength = 255;
  String text = "";

  void repost() {
    widget.onRepostPress(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaxLengthTextInput(
          placeholder: "Напишите свой комментарий",
          maxLength: maxLength,
          onChange: (t) {
            setState(() {
              text = t;
            });
          },
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Text(
            (text.length > maxLength) ? "Максимум $maxLength символов" : "",
            style: TextStyles.interRegular12Red,
          ),
        ),
        SizedBox(height: 24.w),
        PjButton(
            label: "Поделиться",
            onPresser: (text.length <= maxLength) ? repost : null),
        Container(height: 32.w)
      ],
    );
  }
}
