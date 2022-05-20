import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final double? width;
  const Loader({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/images/loader.json', width: width ?? 50.w);
  }
}
