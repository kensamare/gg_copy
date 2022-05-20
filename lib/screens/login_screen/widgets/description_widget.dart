import 'package:flutter/cupertino.dart';
import 'package:gg_copy/project_utils/text_styles.dart';


class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Text(
          'Соцсеть\nдля грустных',
          style: TextStyles.interMedium42,
        ),
        SizedBox(height: 24.0,),
        Text(
          'Выкладывайте грустных себя, показывайте грустных других, грустите вместе',
          style: TextStyles.interRegular14_808080,
        ),
      ],
    );
  }
}
