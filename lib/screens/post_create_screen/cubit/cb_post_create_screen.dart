import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/controllers/rx_menu.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_type.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;

import 'st_post_create_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

class CbPostCreateScreen extends Cubit<StPostCreateScreen> {
  final bool isProfile;

  CbPostCreateScreen(this.isProfile) : super(StPhotoSelect());

  Future<void> sendPost(double width, List<int> bytes, String type, String description) async {
    try {
      if (width < 500) {
        g.Get.dialog(
          cup.CupertinoAlertDialog(
            title: const cup.Text('Маленькое изображение'),
            content: const cup.Text('Ваше изображение слишком мало, чтобы мы могли его опубликовать попробуйте другое'),
            actions: [
              cup.CupertinoDialogAction(
                child: const cup.Text('Закрыть'),
                isDestructiveAction: false,
                onPressed: () {
                  g.Get.back();
                },
              )
            ],
          ),
          barrierDismissible: false,
        );
        return;
      }
      g.Get.dialog(
        cup.CupertinoAlertDialog(
          title: const cup.Text('Публикуем ваш пост'),
          content: cup.Padding(
            padding: cup.EdgeInsets.symmetric(vertical: 8.0.w),
            child: cup.CupertinoActivityIndicator(),
          ),
        ),
        barrierDismissible: false,
      );
      Dio dio = Dio();
      var formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes,
            filename: 'file$type', contentType: MediaType('image', type.replaceAll('.', '')))
      });
      var response = await dio.post(
        'https://media.grustnogram.ru/cors.php',
        data: formData,
        options: Options(headers: {
          'Access-Token': Api.token,
        }),
      );

      log(response.data.toString());
      if(response.data['err'][0] != 0){
        emit(StPostCreateScreenError(error: response.data['err'][0], message: response.data['err_msg'][0]));
        return;
      }
      String fileURL = response.data['data'];
      Map<String, dynamic> responsePost = await Api.post(method: 'posts', testMode: true, isAuth: true, body: {
        'media': [fileURL],
        'text': description,
        'filter': 1,
      });
      if (responsePost['err'][0] != 0) {
        throw APIException(responsePost['err'][0]);
      }
      emit(StPostCreateScreenLoaded());

      ///Старая логика
      // RxMenu menu = g.Get.find(tag: "menu");
      // gSelect = 1;
      // menu.currentIndex.value = 0;

      if (!isProfile) {
        if (g.Get.isDialogOpen!) g.Get.back();
        gSelect = PostTypeValue.my;
        navigateToNav(initIndex: 0);
        // g.Get.offAll(()=>NavigationScreen(init: 0,));
      } else {
        if (g.Get.isDialogOpen!) g.Get.back();
        gSelect = PostTypeValue.warm;
        navigateToNav(initIndex: 4);
        // g.Get.offAll(()=>NavigationScreen(init: 4,));
      }
    } on APIException catch (e) {
      if (e.code == 400) {
        Map<String, dynamic> error = jsonDecode(e.body);
        if (error['err'][0] == 4 || error['err'][0] == 5) {
          g.Get.offAll(LoginScreenProvider(), transition: tr.Transition.cupertino);
          return;
        }
      }
      if (g.Get.isDialogOpen!) {
        g.Get.back();
      }
      emit(StPostCreateScreenError(error: e.code));
    } on StateError catch (e) {
      log('SKIP');
    }
    // } catch (e) {
    //   if (g.Get.isDialogOpen!) {
    //     g.Get.back();
    //   }
    //   emit(StPostCreateScreenError(error: -12, message: e.toString()));
    // }
  }

  void readyForPublish(Image? img, int width, int height) {
    emit(StPhotoChoose(img: img, width: width, height: height));
  }

  // void readyForPublish(Image img) {
  //   emit(StPhotoChoose(img: img));
  // }
}
