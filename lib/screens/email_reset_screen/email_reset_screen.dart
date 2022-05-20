import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/custom_text_field.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cubit/cb_email_reset_screen.dart';
import 'cubit/st_email_reset_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailResetScreen extends StatefulWidget {
  const EmailResetScreen({Key? key}) : super(key: key);

  @override
  _EmailResetScreenState createState() => _EmailResetScreenState();
}

class _EmailResetScreenState extends State<EmailResetScreen> {
  TextEditingController emailController = TextEditingController();
  String emailError = '';
  bool emailIcon = false;
  FocusNode emailFocus = FocusNode();
  
  @override
  void dispose() {
    emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        emailFocus.unfocus();
      },
      child: Scaffold(
        appBar: const PjAppBar(),
        body: BlocConsumer<CbEmailResetScreen, StEmailResetScreen>(
          buildWhen: (prevState, curState) {
            print(curState);
            if (curState is StEmailResetScreenLoaded) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if(state is StEmailResetScreenError){
              Map<String, dynamic> body = jsonDecode(state.message!);
              if (Get.isDialogOpen!) {
                Get.back();
              }
              if(state.error == 4 || body['err'].contains(4)){

                setState(() {
                  emailError = 'почта не найдена';
                  emailIcon = true;
                });
              }
            }
            if(state is StEmailResetScreenLoading){
              Get.dialog(Center(child: Loader()),
                  barrierColor: Colors.white.withOpacity(0.3));
            }
            if (state is StEmailResetScreenComplete) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              Get.back();
              Get.dialog(Center(
                child: Container(margin: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                        color: PjColors.background,
                        borderRadius: BorderRadius.circular(20.w)),
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ссылка для смены пароля отправлена на вашу почту',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: PjColors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0.w,
                                  decoration: TextDecoration.none)),
                          SizedBox(
                            height: 15.w,
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: 48.0.w,
                              child: CupertinoButton(
                                color: Theme.of(context).highlightColor,
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  'понятно',
                                  style: TextStyles.interMedium14,
                                ),
                              ))
                        ],
                      ),
                    )),
              ));
            }
          },
          builder: (context, state) {
            // if (state is StEmailResetScreenLoading) {
            //   return const Center(
            //     child: Loader(),
            //   );
            // }
            if (state is StEmailResetScreenLoaded) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              // emailIcon = false;
              // emailError = '';
              if (Get.isDialogOpen!) {
                Get.back();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.w,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(PjIcons.arrowLeft),
                          Text(
                            'вернуться',
                            style: TextStyles.interRegular14_808080,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'восстановление доступа',
                      style: TextStyles.interMedium20,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      focusNode: emailFocus,
                      hintText: 'email',
                      errorIcon: emailIcon,
                      controller: emailController,
                    ),
                    if(emailError != '')...[
                      Text(emailError, style: TextStyles.interRegular14_808080,)
                    ],
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'введите свой электронный адрес, мы отправим\nвам ссылку для восстановления доступа\nк аккаунту',
                      style: TextStyles.interRegular14_808080,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48.0.w,
                      child: CupertinoButton(
                          color: Theme.of(context).highlightColor,
                          child: Text(
                            'получить ссылку для входа',
                            style: TextStyles.interMedium14,
                          ),
                          onPressed: () {
                            BlocProvider.of<CbEmailResetScreen>(context)
                                .getData(email: emailController.text);
                          }),
                    )
                  ],
                ),
              );
            }
            // if (state is StEmailResetScreenError) {
            //   return Container(color: Colors.red);
            // }
            return Container(color: Colors.grey);
          },
        ),
      ),
    );
  }
}
