import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../project_utils/pj_icons.dart';
import '../../../project_utils/singletons/sg_user.dart';
import '../../../project_utils/text_styles.dart';

class ImageShare extends StatelessWidget {
  ImageShare({Key? key, required this.gKey, required this.isShare, required this.nickname})
      : super(key: key);

  bool isShare;
  GlobalKey gKey;
  String nickname;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: gKey,
      child: Container(
        color: Color(0xFF151515),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Image.asset(PjIcons.rabbits),
              SizedBox(
                height: 25.w,
              ),
              isShare
                  ? Container(
                  width: 270.w,
                  height: 32.w,
                  child: SvgPicture.asset(PjIcons.app_logo))
                  : Container(),
              isShare
                  ? Container(
                      width: 270.w,
                      padding: EdgeInsets.only(top: 6.w, bottom: 20.w),
                      child: Text(
                          "держитесь поближе друг к другу, и всё будет хорошо",
                          style: TextStyles.interMedium16_808080, textAlign: TextAlign.center,))
                  : Container(),
              Text(
                "@" + nickname,
                style: TextStyles.interMedium20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
