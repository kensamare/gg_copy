import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:get/get.dart';

import '../../screens/login_screen/login_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;


class RxBadges extends GetxController {
  Rx<int> count = 0.obs;
  Rx<int> countPosts = 0.obs;
  bool isFirst = true;
  void updateCount() async {
    if (isFirst) {
      try {
        Map<String, dynamic> response = await Api.get(
            method: 'status', isAuth: true, testMode: true);
        Map<String, dynamic> helpResponse = response['data'];
        count.value = helpResponse['notifications_count'];
        countPosts.value = helpResponse['posts_count'];
      } on APIException catch(e) {
        if(e.code == 400){
          Map<String, dynamic> error = jsonDecode(e.body);
          if(error['err'][0] == 4 || error['err'][0] == 5){
            Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
            return;
          }
        }
      } on StateError catch(e){
        log('SKIP');
      }
    }
    isFirst = false;
      Timer.periodic(Duration(minutes: 1), (timer) async {
        try {
          Map<String, dynamic> response = await Api.get(
              method: 'status', isAuth: true, testMode: true);
          Map<String, dynamic> helpResponse = response['data'];
          count.value = helpResponse['notifications_count'];
          countPosts.value = helpResponse['posts_count'];
        } on APIException catch(e) {
          if(e.code == 400){
            Map<String, dynamic> error = jsonDecode(e.body);
            if(error['err'][0] == 4 || error['err'][0] == 5){
              Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
              return;
            }
          }
        } on StateError catch(e){
          log('SKIP');
        }
      });
  }
}