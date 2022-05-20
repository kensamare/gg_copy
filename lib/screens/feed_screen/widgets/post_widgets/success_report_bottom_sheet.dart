import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/success_sheet_content.dart';

class SuccessReportBottomSheet extends StatelessWidget {
  const SuccessReportBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuccessSheetContent(
        text: 'Спасибо, что рассказали. Мы скоро отреагируем');
  }
}
