import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gg_copy/project_widgets/custom_text_field.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../project_utils/pj_colors.dart';
import '../../project_utils/pj_icons.dart';
import '../../project_utils/text_styles.dart';
import 'cubit/cb_setting_screen.dart';
import 'cubit/st_setting_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isNotify;
  late TextEditingController currentPassword;
  late TextEditingController newPassword;
  late TextEditingController repeatNewPassword;
  late GlobalKey<FormState> formKey;

  String? currentMessage = '';
  String? newMessage = '';
  String? repeatMessage = '';
  bool currentError = false;
  bool newError = false;
  bool repeatError = false;

  @override
  void initState() {
    isNotify = true;
    currentPassword = TextEditingController();
    newPassword = TextEditingController();
    repeatNewPassword = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PjAppBar(
        leading: true,
        title: "вернуться",
        action: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
          },
          child: GestureDetector(
            onTap: () async {
              log(currentPassword.text, name: "currentPassword");
                if (currentPassword.text.isEmpty) {
                  setState(() {
                    currentMessage = 'поле не должно быть пустым';
                    currentError = true;
                  });
                }else{
                  log('11');
                  setState(() {
                    currentMessage = '';
                    currentError = false;
                  });
                }
                if (newPassword.text.isEmpty) {
                  setState(() {
                    newMessage = 'поле не должно быть пустым';
                    newError = true;
                  });
                }else{
                  setState(() {
                    newMessage = '';
                    newError = false;
                  });
                }
                if (repeatNewPassword.text.isEmpty) {
                  setState(() {
                    repeatMessage = 'поле не должно быть пустым';
                    repeatError = true;
                  });
                }else{
                  setState(() {
                    repeatMessage = '';
                    repeatError = false;
                  });
                }
              if(newPassword.text.isNotEmpty){
                if(newPassword.text.length < 8){
                  setState(() {
                    newMessage = 'пароль должен быть не менее 8 символов';
                    newError = true;
                  });
                }else{
                  setState(() {
                    newMessage = '';
                    newError = false;
                  });
                }
                if(newPassword.text != repeatNewPassword.text){
                  setState(() {
                    repeatMessage = 'пароли не совпадают';
                    repeatError = true;
                  });
                }else{
                  setState(() {
                    repeatMessage = '';
                    repeatError = false;
                  });
                }
              }
              if (newMessage == '' && repeatMessage == '' && currentMessage == '') {
                BlocProvider.of<CbSettingScreen>(context).changePassword(currentPassword.text, newPassword.text);
                Future.delayed(const Duration(seconds: 2), () {
                  Get.back();
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              child: Text("Сохранить", style: TextStyles.interMedium14_b8),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<CbSettingScreen, StSettingScreen>(
          listener: (context, state) {
            if (state is StSettingSuccessChange) {
              Get.bottomSheet(Container(
                height: 200.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.0.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 26.w,
                          ),
                          SvgPicture.asset(
                            PjIcons.appleid,
                            width: 44.w,
                            height: 44.w,
                          ),
                          SizedBox(
                            height: 26.w,
                          ),
                          SizedBox(
                            width: 224.w,
                            child: Text(
                              'Пароль успешно изменен',
                              textAlign: TextAlign.center,
                              style: TextStyles.interMedium16_808080,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              );
            }
          },
          builder: (context, state) {
            if (state is StSettingScreenInit) {
            }
            if (state is StSettingScreenLoading) {
              return const Center(
                child: Loader(),
              );
            }
            if (state is StSettingScreenLoaded) {
              return Container(color: Colors.green);
            }
            if (state is StSettingScreenError) {
              return ErrWidget(errorCode: state.error.toString(),);
            }
            if (state is StSettingSuccessChange) {
            }
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 14.w),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                // Text(
                //   "Уведомления",
                //   style: TextStyles.interMedium16_b8,
                // ),
                // SizedBox(
                //   height: 12.w,
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).focusColor,
                //     borderRadius: BorderRadius.circular(10.w),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //         vertical: 15.w, horizontal: 18.w),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text("Уведомления", style: TextStyles.interRegular14),
                //         FlutterSwitch(
                //           activeColor: Color(0xFF353535),
                //           inactiveColor: Color(0xFF262626),
                //           width: 42.w,
                //           height: 24.w,
                //           toggleSize: 20.w,
                //           padding: 2.w,
                //           onToggle: (bool value) {
                //             setState(() {
                //               isNotify = value;
                //             });
                //           },
                //           value: isNotify,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20.w),
                Text(
                  "Смена пароля",
                  style: TextStyles.interMedium16_b8,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.w),
                      CustomTextField(
                        errorIcon: currentError,
                        hintText: 'Текущий пароль',
                        obscure: true,
                        controller: currentPassword,
                      ),
                      if (currentMessage != '') ...[
                        Text(
                          currentMessage!,
                          style: TextStyles.interRegular14_808080,
                        )
                      ],
                      SizedBox(height: 12.w),
                      CustomTextField(
                        errorIcon: newError,
                        hintText: 'Новый пароль',
                        obscure: true,
                        controller: newPassword,
                      ),
                      if (newMessage != '') ...[
                        Text(
                          newMessage!,
                          style: TextStyles.interRegular14_808080,
                        )
                      ],
                      SizedBox(height: 12.w),
                      CustomTextField(
                        errorIcon: repeatError,
                        hintText: 'Повторите пароль',
                        obscure: true,
                        controller: repeatNewPassword,
                      ),
                      if (repeatMessage != '') ...[
                        Text(
                          repeatMessage!,
                          style: TextStyles.interRegular14_808080,
                        )
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
