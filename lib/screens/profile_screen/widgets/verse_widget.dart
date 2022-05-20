import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/models/poem_model.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';

import '../../../project_utils/text_styles.dart';


class VerseWidget extends StatelessWidget {
  PoemModel poem;
  VerseWidget({required this.poem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 34.w),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32.w,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 63.w - 32.w),
                  child: Text(
                    "если нет грустных фото, почитайте грустный стих",
                    style: TextStyles.interRegular14_808080,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.w,),
                Text(
                  poem.title!,
                  style: TextStyles.interMedium20,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.w,),
                Text(
                  poem.poem!,
                  style: TextStyles.interMedium16o70,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.w,),
                poem.avatar != null ?
                CachedNetworkImage(
                  imageUrl: poem.avatar!,
                  imageBuilder: (context, pro) => Container(
                    width: 32.0.w,
                    height: 32.0.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: pro, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, str) => Container(
                    width: 32.0.w,
                    height: 32.0.w,
                    child: SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ):
                Container(
                  width: 32.0.w,
                  height: 32.0.w,
                  child: SvgPicture.asset(PjIcons.avatar, fit: BoxFit.cover),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 6.w,),
                Text(
                  poem.author!,
                  style: TextStyles.interMedium14,
                ),
                SizedBox(height: 6.w,),
                Text(
                  poem.year.toString(),
                  style: TextStyles.interRegular12_808080,
                ),
                SizedBox(height: 40.w,)



              ],
            ),
          )
    );
  }
}
