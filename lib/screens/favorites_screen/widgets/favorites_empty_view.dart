import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/pj_button.dart';

import '../../../project_utils/pj_colors.dart';

class FavoritesEmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Flexible(
              flex: 1,
              child: SizedBox.expand(),
            ),
            Text(
              'собирайте коллекцию',
              style: TextStyles.interMedium42,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Text(
                'Ваша личная коллекция любимых публикаций, которые не хочется потерять',
                style: TextStyles.interMedium16.copyWith(
                  color: PjColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.w),
            PjButton(
              padding: 0.0,
              label: 'перейти на главную ленту',
              onPresser: Get.back,
              color: PjColors.black2,
            ),
            const Flexible(
              flex: 3,
              child: SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
  }
}
