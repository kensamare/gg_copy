import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../login_screen/login_screen_provider.dart';
import 'st_setting_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbSettingScreen extends Cubit<StSettingScreen> {
  CbSettingScreen() : super(StSettingScreenInit());
  
  Future<void> changePassword(String oldPass, String newPass) async {
  try {
      Map<String, dynamic> response =
          await Api.put(method: 'users/self', isAuth: true, testMode: true, body: {
            'old_password': oldPass,
            'new_password': newPass
          });
      emit(StSettingSuccessChange());
    } on APIException catch (e) {
    if(e.code == 400){
      Map<String, dynamic> error = jsonDecode(e.body);
      if(error['err'][0] == 4 || error['err'][0] == 5){
        Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
        return;
      }
    }
      emit(StSettingScreenError(error: e.code));
    } on StateError catch(e){
    log('SKIP');
  }
  }
}
    