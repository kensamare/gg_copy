import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'st_sms_check_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbSmsCheckScreen extends Cubit<StSmsCheckScreen> {
  CbSmsCheckScreen() : super(StSmsCheckScreenLoaded());

  Future<void> getData({required String phone, required String code}) async {
    try {
      emit(StSmsCheckScreenLoading());
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? a = await messaging.getToken();
      Map<String, dynamic> response =
          await Api.post(method: 'phoneactivate', testMode: true, body: {
            "phone": phone,
            "code": code,
            "fcmid": a
          });
      Api.setToken(response['data']['access_token']);
      emit(StSmsCheckScreenLogin());
    } on APIException catch (e) {
        emit(StSmsCheckScreenError(error: jsonDecode(e.body)['err'][0]));
    }  on StateError catch(e){
      log('SKIP');
    }
  }

  Future<void> send_sms(
      {required String phone_key, required String phone_number}) async {
    try {
      emit(StSmsCheckScreenLoading());
      Map<String, dynamic> response =
      await Api.post(method: 'callme', testMode: true, body: {
        "phone_key": phone_key,
        "phone": phone_number
      });
      if(!response['err'].contains(0)){
        emit(StSmsCheckScreenError(error: response['err'][0]));
      }
      emit(StSmsCheckScreenEnterCode());
    } on APIException catch (e) {
      if(jsonDecode(e.body)['err'][0] == 121) {
        Api.setToken(jsonDecode(e.body)['data']['access_token']);
        emit(StSmsCheckScreenLogin());
      }else{
        emit(StSmsCheckScreenError(error: jsonDecode(e.body)['err'][0]));
      }
    } on StateError catch(e){
      log('SKIP');
    }
  }
}
