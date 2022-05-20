import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/screens/appeal_form_screen/widgets/appeal_form.dart';

import '../../project_utils/text_styles.dart';
import '../../project_widgets/pj_appbar.dart';

class AppealFormScreen extends StatelessWidget {
  const AppealFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PjAppBar(
        leading: true,
        title: 'вернуться',
        action: SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppealForm()
          ],
        ),
      ),
    );
  }
}
