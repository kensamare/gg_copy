import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';

import '../../../models/self_model.dart';
import '../../../project_utils/controllers/rx_menu_avatar.dart';
import 'st_edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:path/path.dart' as p;

class CbEditProfileScreen extends Cubit<StEditProfileScreen> {
  CbEditProfileScreen() : super(StEditProfileScreenInit());

  Future<void> updateProfile(
      {required SelfModel model,
      required String nick,
      required String name,
      required String about,
      required String avatar,
        bool deletePhoto = false}) async {

    if (model.about == about && model.nickname == nick && model.name == name && avatar == "" && !deletePhoto) {
      emit(StEditProfileScreenLoaded());
      return;
    }


    try {
      String imageUrl = "";
      if(avatar != "" && !deletePhoto){
        String flname = model.nickname!.replaceAll(".", "");
        flname += "_avatar_";
        flname += DateTime.now().microsecondsSinceEpoch.toString();
        if(p.extension(avatar)=='.gif'){
          flname += ".gif";
        } else{
          flname += ".jpg";
        }
        print("FILENAME  $avatar");
        d.FormData formData = d.FormData.fromMap({
          "file": d.MultipartFile.fromBytes(File(avatar).readAsBytesSync(), filename: flname)
        });
        log('TUT');

        var response = await d.Dio().post(
            "https://media.grustnogram.ru/cors.php",
            data: formData,
          options: d.Options(
            headers:{'Access-Token': Api.token}
          )
        );

        Map<String, dynamic> mocha = response.data;
        if (response.data['err'][0] == 1) {
          Get.dialog(
            CupertinoAlertDialog(
              title: const Text('Маленькое изображение'),
              content: const Text('Ваше изображение слишком мало, чтобы мы могли его опубликовать попробуйте другое'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Закрыть'),
                  isDestructiveAction: false,
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
            barrierDismissible: false,
          );
          emit(StEditProfileScreenInit());
          return;
        }
        log(response.data['err'].toString(), name: "data");
        print("Качнуло 1");
        print(mocha["data"]);
        if(mocha["err"][0] == 0){
          print("Качнуло 2");
          imageUrl = mocha["data"];
          RxMenuAvatar avatarController = Get.find(tag: "menuAvatar");
          avatarController.url.value = imageUrl;
        }
      }

      Map<String, String> bodyRequest = {"nickname": nick, "name": name, "about": about};
      if(imageUrl != ""){
        bodyRequest.addAll({"avatar": imageUrl});
      }else if (deletePhoto){
        bodyRequest.addAll({"avatar": "https://560621.selcdn.ru/gg/empty_profile.jpg"});
      }

      Map<String, dynamic> response = await Api.put(
          method: 'users/self',
          isAuth: true,
          testMode: true,
          body: bodyRequest);
      emit(StEditProfileScreenLoaded());
    } on APIException catch (e) {
      if(e.code == 400){
        Map<String, dynamic> error = jsonDecode(e.body);
        if(error['err'][0] == 4 || error['err'][0] == 5){
          Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        } else if (error['err'][0] == 101) {
          emit(StEditProfileScreenInit(isErrorNickname: true));
          return;
        }
      }
      emit(StEditProfileScreenError(error: e.code));
    } on StateError catch(e){
      log('SKIP');
    }
  }
}
