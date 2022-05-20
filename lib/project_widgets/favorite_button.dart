import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool state;
  final void Function()? onPress;

  const FavoriteButton({ Key? key , required this.state, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        color: state ?  PjColors.white : PjColors.grey3,
        icon: Icon(state ? Icons.star : Icons.star_border), 
        onPressed: onPress,
        padding: EdgeInsets.zero, 
        iconSize: 28.w,
        splashRadius: 0.1,
      ), 
      width: 28.w, 
      height: 28.w, 
      padding: EdgeInsets.zero
    );
  }
}