import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../project_utils/text_styles.dart';

class Counter extends StatefulWidget {
  String label;
  int count;
  Function() open;
  Counter({required this.label, required this.count, required this.open});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: widget.open,
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Column(
          children: [
            Text(
              widget.count.toString(),

              style: TextStyles.interSemiBold18,
            ),
            SizedBox(
              height: 10.w,
            ),
            Text(
              widget.label,
              style: TextStyles.interRegular14,
            )

          ],
        ),
      ),
    );
  }
}
