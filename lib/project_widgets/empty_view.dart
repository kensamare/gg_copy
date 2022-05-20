import 'package:flutter/cupertino.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/ui/models/empty_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EmptyView extends StatelessWidget {
  final EmptyViewModel viewModel;

  const EmptyView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PjColors.background,
      padding: EdgeInsets.symmetric(horizontal: 31.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            viewModel.title,
            style: TextStyles.interMedium42White,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Text(
              viewModel.description,
              style: TextStyles.interMedium16.copyWith(color: PjColors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.w),
          ...viewModel.buttons.map((el) {
            return CupertinoButton(
                color: PjColors.lightGrey,
                child: Container(
                  width: 312.w,
                  alignment: Alignment.center,
                  child: Text(
                    el.text,
                    style: TextStyles.interRegular12,
                  ),
                ),
                onPressed: el.action);
          })
        ],
      ),
    );
  }
}
