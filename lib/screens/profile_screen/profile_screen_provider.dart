import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:uuid/uuid.dart';
import 'profile_screen.dart';
import 'cubit/cb_profile_screen.dart';
import 'cubit/st_profile_screen.dart';


class ProfileScreenProvider extends StatelessWidget {
  String nickname;
  final bool isMenu;
  String tag;
   ProfileScreenProvider({required this.nickname, this.isMenu = false, this.tag = ''}){tag = Uuid().v4();Get.put(PostController(), tag: tag);}

  @override
  Widget build(BuildContext context) {
     log(tag.toString(), name: "STARTTAG");
    return BlocProvider<CbProfileScreen>(
      create: (context) => CbProfileScreen(),
      child:  ProfileScreen(nickname: nickname, isMenu: isMenu, tag: tag,),
    );
  }
}    
    