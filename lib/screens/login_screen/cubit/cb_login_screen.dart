import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

import 'st_login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbLoginScreen extends Cubit<StLoginScreen> {
  CbLoginScreen() : super(StAuth());
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> auth(String email, String password) async {
    try {
      emit(StLoginScreenLoading());

      String? a = await messaging.getToken();
      Map<String, dynamic> response = await Api.post(
        method: 'sessions',
        testMode: true,
        body: {"email": email, "password": password, "fcmid": a},
      );
      if(response['data']['status'] ==0){
        emit(StLoginScreenVerification(phone_key: response['data']['phone_key']));
      }else {
        Api.setToken(response['data']['access_token']);

        emit(StLoginScreenLoaded(body: response.toString()));
      }
    } on APIException catch (e) {
      log(e.body, name: 'CUBERRMES');
      emit(StLoginScreenError(error: e.code, message: e.body));
    } on StateError catch(e){
      log('SKIP');
    }
  }

  Future<void> singUp(String nickname, String email, String password) async {
    try {
      emit(StLoginScreenLoading());
      String? a = await messaging.getToken();
      Map<String, dynamic> response = await Api.post(
        method: 'users',
        testMode: true,
        body: {
          'nickname': nickname,
          'email': email,
          'password': password,
          'fcmid': a
        },
      );
      // Api.setToken(jsonDecode(response['data']['access_token']));

      if(response['data']['status'] == 0){
        GetStorage().write('phone_key', response['data']['phone_key']);
        emit(StLoginScreenVerification(phone_key: response['data']['phone_key']));
      }else{
        Api.setToken(response['data']['access_token']);

        emit(StLoginScreenLoaded(body: response.toString()));
      }
    } on APIException catch (e) {
      emit(StLoginScreenError(error: e.code, message: e.body));
    } on StateError catch(e){
      log('SKIP');
    }
  }

  void changeState(bool isAuth) {
    if (isAuth) {
      emit(StRegistration());
    } else {
      emit(StAuth());
    }
  }
}
