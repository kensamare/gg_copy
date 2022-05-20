import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/text_styles.dart';


class ShowComments extends StatelessWidget {
  const ShowComments({Key? key, required this.index,}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/post-comment-page', arguments: index,);
      },
      child: SizedBox(
        height: 35.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 2.0.w,
            ),
            child: Text(
              'посмотреть комментарии',
              style: TextStyles.interRegular14_808080,
            ),
          ),
        ),
      ),
    );
  }
}
