import 'package:flutter/cupertino.dart';

import '../../../project_utils/text_styles.dart';

class UserStatsElement extends StatelessWidget {
  const UserStatsElement({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);
  final String text;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value.toString(),
          style: TextStyles.interSemiBold18,
        ),
        const Spacer(),
        Text(
          text,
          style: TextStyles.interRegular12o70,
        ),
      ],
    );
  }
}
