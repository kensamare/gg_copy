import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/models/self_model.dart';

import '../controllers/rx_menu_avatar.dart';

class SgUser {
  SgUser._();

  static SgUser instance = SgUser._();

  static SelfModel _user = SelfModel();

  SelfModel get user => _user;

  set user(SelfModel user){
    _user = user;
    if(user.avatar100 != null){
      RxMenuAvatar avatarController = Get.find(tag: "menuAvatar");
      avatarController.url.value = user.avatar100!;
    }
  }

  void clean(){
    _user = SelfModel();
    RxMenuAvatar avatarController = Get.find(tag: "menuAvatar");
    avatarController.url.value = "";
  }
}