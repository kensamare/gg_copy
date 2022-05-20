import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/screens/profile_screen/widgets/feedback.dart' as pf;
import '../../../project_utils/controllers/rx_menu.dart';
import '../../../project_utils/pj_icons.dart';
import '../../../project_utils/text_styles.dart';
import '../../setting_screen/setting_screen_provider.dart';

class SettingBottomSheet extends StatelessWidget {
  final bool isSelf;
  final int userId;
  final String userNickname;
  final Future<void>Function() deleteSession;
  final Function()? bloc;
  const SettingBottomSheet({Key? key, required this.isSelf, required this.userId, required this.userNickname, required this.deleteSession, this.bloc}) : super(key: key);

  void logOut() async{
    await deleteSession();
    Api.setToken("");
    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache();
    SgUser.instance.clean();
    // RxMenu menuController = Get.find(tag: "menu");
    // menuController.currentIndex.value = 0;
    Get.offAll(LoginScreenProvider());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.w,
            ),
            if (isSelf) ...[
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      'настройки',
                      style: TextStyles.interMedium14,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SvgPicture.asset(PjIcons.arrowRight),
                  )
                ],
              ),
              onPressed: () {
                Get.to(() => SettingScreenProvider(), transition: tr.Transition.cupertino);
              },
            ),
            SizedBox(
              height: 10.w,
            ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        'обратная связь',
                        style: TextStyles.interMedium14,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 16.w),
                      child: SvgPicture.asset(PjIcons.arrowRight),
                    )
                  ],
                ),
                onPressed: () {
                  Get.back();
                  Get.bottomSheet(pf.Feedback(),);
                  // Get.to(() => FeedbackFromProfileScreen(), transition: tr.Transition.cupertino);
                },
              ),
              SizedBox(
                height: 10.w,
              ),
            CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Row(children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    'выйти из профиля',
                    style: TextStyles.interMedium14Red,
                  ),
                ]),
                onPressed: logOut),
            SizedBox(
              height: 20.w,
            ),
            ] else ...[
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).canvasColor,
                child: Center(
                  child: Text(
                    'заблокировать $userNickname',
                    style: TextStyles.interMedium14Red,
                  ),
                ),
                onPressed: () async {
                  try {
                    Map<String, dynamic> response = await Api.post(method: 'users/$userId/block', isAuth: true, body: {});
                    Get.back();
                    if(bloc != null){
                      bloc!();
                    }
                  } on APIException catch(e) {
                    if(e.code == 400){
                      Map<String, dynamic> error = jsonDecode(e.body);
                      if(error['err'][0] == 4 || error['err'][0] == 5){
                        Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
                      }
                    }
                  } on StateError catch(e){
                    log('SKIP');
                  }
                  Get.back();
                },
              ),
              SizedBox(height: 20.w,),
            ]
          ],
        ),
      ),
    );
  }
}
