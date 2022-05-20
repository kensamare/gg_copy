import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/post_create_screen/post_create_screen_provider.dart';


class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Get.to(()=>PostCreateScreenProvider(isProfile: true,));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 32.w, right: 14.w, left: 14.w),
        child: DottedBorder(
          dashPattern: [5,2],
          color: PjColors.black53,
          radius:  Radius.circular(10.w),
          borderType: BorderType.RRect,
          padding: EdgeInsets.zero,
          child: Container(
            height: 84.w,
            width: 347.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: PjColors.blackAnother,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(PjIcons.add, height: 22.w, width: 22.w,),
                SizedBox(width: 17.w,),
                Text(
                    "загрузить первую \nгрустную фотографию",
                    style: TextStyles.interRegular14,
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
