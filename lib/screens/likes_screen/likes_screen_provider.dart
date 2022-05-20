import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gg_copy/project_utils/controllers/rx_badges.dart';
import 'likes_screen.dart';
import 'cubit/cb_likes_screen.dart';
import 'cubit/st_likes_screen.dart';
import 'package:get/get.dart';

class LikesScreenProvider extends StatelessWidget {
  const LikesScreenProvider({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return BlocProvider<CbLikesScreen>(
      create: (context) => CbLikesScreen(),
      child: const LikesScreen(),
    );
  }
}    
    