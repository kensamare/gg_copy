import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';

import '../../../models/self_model.dart';
import '../../../project_utils/text_styles.dart';

class SearchUserCard extends StatelessWidget {
  final SelfModel model;
  const SearchUserCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name =  model.name!.length > 40 ? model.name!.substring(0, 40) + "..." : model.name!;
    String nick =  model.nickname!.length > 40 ? model.nickname!.substring(0, 40) + "..." : model.nickname!;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if (SgUser.instance.user.nickname == model.nickname!) {
          navigateToNav(initIndex: 4);
          // Get.offAll(() => NavigationScreen(
          //   init: 4,
          // ));
          return;
        }
        Get.to(()=>ProfileScreenProvider(nickname: model.nickname!),transition: tr.Transition.cupertino);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SizedBox(
              height: 48.w,
              width: 48.w,
              child: CircleAvatar(
                backgroundImage: NetworkImage(model.avatar100!),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nick ,style: TextStyles.interRegular14),
                SizedBox(
                  height:4.w,
                ),
                Text(name, style: TextStyles.interRegular12_808080,),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
