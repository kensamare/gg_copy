import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../project_utils/text_styles.dart';

class ReasonBottomSheet extends StatelessWidget {
  const ReasonBottomSheet({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

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
            CupertinoButton(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).splashColor,
              child: Center(
                child: Text(
                  'указать на ошибки',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                controller.text = 'указать на ошибки';
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).splashColor,
              child: Center(
                child: Text(
                  'предложить',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                controller.text = 'предложить';
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).splashColor,
              child: Center(
                child: Text(
                  'пожаловаться',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                controller.text = 'пожаловаться';
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.all(16.0),
              color: Theme.of(context).splashColor,
              child: Center(
                child: Text(
                  'что-то другое',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () {
                controller.text = 'что-то другое';
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
