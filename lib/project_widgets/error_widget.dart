import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/presentation/app.dart';

import '../project_utils/controllers/rx_menu.dart';
import '../project_utils/pj_icons.dart';
import '../project_utils/text_styles.dart';

class ErrWidget extends StatefulWidget {
  ErrWidget({Key? key, required this.errorCode, this.callback, this.menuHas=true, this.buttonText = ''}) : super(key: key);

  String errorCode;
  final Function()? callback;
  final bool menuHas;
  final String buttonText;

  @override
  State<ErrWidget> createState() => _ErrWidgetState();
}

class _ErrWidgetState extends State<ErrWidget> {
  late RxMenu menu;

  @override
  void initState() {

    if(widget.menuHas){
      menu = Get.find(tag: "menu");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            PjIcons.errorHeart,
            width: 240.w,
            height: 240.w,
          ),
          Text(
            "Что-то пошло не так..",
            style: TextStyles.interMedium24,
          ),
          SizedBox(height: 10.w),
          Text(
            widget.errorCode == '0' ? 'нет соединения с сервером': "ошибка ${widget.errorCode}",
            style: TextStyles.interMedium16_808080,
          ),
          SizedBox(height: 32.w),
          GestureDetector(
            onTap: () {
              if(widget.callback != null){
                widget.callback!();
              }
              if(widget.menuHas){
                navigateToNav();
                // menu.currentIndex.value = 0;
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Theme.of(context).focusColor,
                ),
                height: 46.w,
                width: 312.w,
                child: Center(
                    child: widget.buttonText.isEmpty ? Text(widget.menuHas ? menu.currentIndex.value == 0 ? "Повторить попытку" : "Переместиться на главную": "Повторить попытку",
                        style: TextStyles.interMedium14) : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(widget.buttonText, style: TextStyles.interMedium14, textAlign: TextAlign.center,),
                        ))),
          ),
          SizedBox(height: 10.w),
          SizedBox(
            width: 270.w,
            child: Text(
              "Пока мы выясняем, в чем проблема, предлагаем вернуться на главную, скоро починим",
              style: TextStyles.interMedium14_808080,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
