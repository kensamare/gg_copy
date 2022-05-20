import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/success_report_bottom_sheet.dart';

import '../../../../project_utils/singletons/sg_user.dart';
import '../../../comment_screen/cubit/cb_comment_screen.dart';

class ReportBottomSheet extends StatelessWidget {
  final int? postId;
  final int? commentId;
  final Function()? callback;
  final int? canDelete;
  final int? userId;
  final bool blockUser;
  final String? nickname;

  const ReportBottomSheet({this.postId, this.commentId,  this.callback, this.canDelete, this.nickname, this.userId, this.blockUser = false, Key? key}) : super(key: key);

  void sendReport(context, int type, bool isComment) {
    Get.back();
    Get.bottomSheet(const SuccessReportBottomSheet());
    // Navigator.pop(context);
    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   context: context,
    //   builder: (context) {
    //     return const SuccessReportBottomSheet();
    //   },
    // );
    try{
      if (blockUser) {
        Api.post(method: 'users/$userId/complaint', body: {"type": type}, isAuth: true, testMode: true);
      } else {
        Api.post(
            method: isComment
                ? 'posts/comments/${commentId}/complaint'
                : 'posts/${postId}/complaint',
            body: isComment ? {} : {"type": type},
            isAuth: true,
            testMode: true);
      }
    } catch(e){

    }

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
            (callback != null) && (canDelete == 1) ? CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'удалить комментарий',
                  style: TextStyles.interMedium14Red,
                ),
              ),
              onPressed: callback,
            ) : Container(),
            (callback != null) && (canDelete == 1) ? SizedBox(
              height: 10.w,
            ) : Container(),
            nickname == null ? CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'содержит недопустимые материалы',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                log(SgUser.instance.user.nickname.toString());
                sendReport(context, 1, postId == null ? true : false);
              },
            ) : Container(),
            SizedBox(
              height: nickname == null ? 10.w : 0.w,
            ),
            nickname == null ? CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'оскорбляет меня',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                sendReport(context, 2, postId == null ? true : false);
              },
            ) : Container(),
            SizedBox(
              height: nickname == null ? 10.w : 0.w,
            ),
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   color: Theme.of(context).canvasColor,
            //   child: Center(
            //     child: Text(
            //       'оскорбляет Российскую Федерацию',
            //       style: TextStyles.interMedium14,
            //     ),
            //   ),
            //   onPressed: () {
            //     sendReport(context, 3, postId == null ? true : false);
            //   },
            // ),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }


}
