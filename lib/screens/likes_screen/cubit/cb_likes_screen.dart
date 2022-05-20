import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/models/notifications_model.dart';

import '../../login_screen/login_screen_provider.dart';
import 'st_likes_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

class CbLikesScreen extends Cubit<StLikesScreen> {
  CbLikesScreen() : super(StLikesScreenLoading()) {
  }

  Future<void> getData() async {
    List<NotificationsModel> result = [];
    try {
      Map<String, dynamic> DataResponse = await Api.get(
        method: 'notifications',
        testMode: true,
        isAuth: true,
      );
      for (Map<String, dynamic> elm in DataResponse['data']) {
        result.add(NotificationsModel.fromJson(elm));
      }
      emit(StLikesScreenLoaded(result: result));
    } on APIException catch (e) {
      if(e.code == 400){
        Map<String, dynamic> error = jsonDecode(e.body);
        if(error['err'][0] == 4 || error['err'][0] == 5){
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      emit(StLikesScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }
}
