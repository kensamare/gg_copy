import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cb_liked_screen.dart';
import 'liked_screen.dart';

class LikedScreenProvider extends StatelessWidget {
  final int index;
  final  bool showAppbar;
  final String tag;
  const LikedScreenProvider({required this.index, Key? key,   this.showAppbar = true, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbLikedScreen>(
      create: (context) => CbLikedScreen(),
      child: LikedScreen(index: index, tag: tag,),
    );
  }
}
