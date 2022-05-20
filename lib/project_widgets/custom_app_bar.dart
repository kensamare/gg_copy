import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';

import '../project_utils/text_styles.dart';

abstract class CustomAppBar extends StatelessWidget {
  abstract final String name;
  abstract final Widget? thirdIcon;

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyles.interMedium24,
            ),
            const Spacer(),
            SvgPicture.asset(
              PjIcons.plus,
              width: 22,
            ),
            const SizedBox(
              width: 20,
            ),
            SvgPicture.asset(
              PjIcons.heart,
              width: 22,
            ),
            if (thirdIcon != null)
              const SizedBox(
                width: 20,
              ),
            thirdIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
