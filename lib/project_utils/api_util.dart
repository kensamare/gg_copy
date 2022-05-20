import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:get/get.dart';

import '../screens/login_screen/login_screen_provider.dart';

class ApiUtil {
  static Future<void> guardApiCall(
    Future<void> Function() invoker, {
    void Function(int e)? onError,
  }) async {
    try {
      await invoker();
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          Get.offAll(
            const LoginScreenProvider(),
            transition: Transition.cupertino,
          );
          return;
        }
      }

      if (onError != null) {
        onError(e.code);
      }
    } on StateError catch (_) {
      log('SKIP');
    }
  }
}
