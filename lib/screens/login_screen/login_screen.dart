import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/presentation/pages/feed_page.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen_provider.dart';
import 'package:gg_copy/screens/login_screen/widgets/change_widget_card.dart';
import 'package:gg_copy/screens/login_screen/widgets/description_widget.dart';
import 'package:gg_copy/screens/login_screen/widgets/login_widget.dart';
import 'package:gg_copy/screens/login_screen/widgets/sign_up_widget.dart';
import 'package:gg_copy/screens/sms_check_screen/sms_check_screen_provider.dart';
import '../../project_utils/pj_icons.dart';
import 'cubit/cb_login_screen.dart';
import 'cubit/st_login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMessage = '';
  List<int> errorList = [];
  late Map<String, dynamic> _str_mes;
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode repeatFocus = FocusNode();
  bool isSignUp = false;

  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    nameFocus.dispose();
    repeatFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () {
          emailFocus.unfocus();
          passFocus.unfocus();
          nameFocus.unfocus();
          repeatFocus.unfocus();
        },
        child: Scaffold(
          backgroundColor: PjColors.background,
          // appBar: const PjAppBar(),
          body: BlocConsumer<CbLoginScreen, StLoginScreen>(
              listener: (context, state) {
            print(state);
            if (state is StLoginScreenLoading) {
              Get.dialog(Center(child: Loader()),
                  barrierColor: Colors.white.withOpacity(0.3));
            }
            if (state is StLoginScreenLoaded) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              navigateToNav(initIndex: 0);
              // Get.offAll(() => NavigationScreen());
            }
            if (state is StLoginScreenVerification) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              Get.to(() => SmsCheckScreenProvider(
                    phone_key: state.phone_key,
                  ));
            }
            if (state is StLoginScreenError) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              errorList = [];
              _str_mes = jsonDecode(state.message!);
              setState(() {
                log(state.error.toString(), name: 'ERRORAUTH');
                if (_str_mes['err'].contains(102) ||
                    _str_mes['err'].contains(103)) {
                  errorMessage = 'неверно введен логин/пароль';
                } else if (_str_mes['err'].contains(100)) {
                  errorList.add(100);
                } else if (_str_mes['err'].contains(101)) {
                  errorList.add(101);
                } else if (_str_mes['err'].contains(111)) {
                  errorList.add(111);
                } else{
                  errorMessage = '';
                }
              });
            }
            if (state is StRegistration) {
              isSignUp = true;
            }
              }, buildWhen: (prevState, curState) {
            print(curState);
            if (curState is StAuth || curState is StRegistration) {
              return true;
            }
            return false;
          }, builder: (context, state) {
            print(state);
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        isSignUp ? GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            BlocProvider.of<CbLoginScreen>(context).changeState(BlocProvider.of<CbLoginScreen>(context)
                                .state is StAuth);
                            setState(() {
                              isSignUp = false;
                            });
                          },
                          child: SvgPicture.asset(
                            PjIcons.arrowLeft,
                            width: 30.w,
                            height: 30.w,
                          ),
                        ) : Container(),
                        isSignUp ? SizedBox(width: 10.w,) : Container(),
                        Text(
                          'грустнограм',
                          style: TextStyles.interMedium24,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15.w,
                    ),
                    Expanded(
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          const DescriptionWidget(),

                          if (state is StAuth)
                            LoginWidget(
                              emailFocus: emailFocus,
                              passFocus: passFocus,
                              errorAuth: errorMessage,
                            ),
                          //
                          if (state is StRegistration)
                            SignUpWidget(
                              errorList: errorList,
                              nameFocus: nameFocus,
                              passFocus: passFocus,
                              emailFocus: emailFocus,
                              repeatFocus: repeatFocus,
                            ),

                          // Obx(() {
                          //   if (registrationController.widgetName.value == 'authorize') {
                          //     return LoginWidget();
                          //   }
                          //   if (registrationController.widgetName.value == 'registration') {
                          //     return SignUpWidget();
                          //   }
                          //   return SignUpWidget();
                          // }
                          // ),
                          Container(
                            height: 1.w,
                            color: const Color(0xFF2B2B2B),
                          ),
                          SizedBox(
                            height: 32.w,
                          ),
                          ChangeWidgetCard(
                            isAuth: BlocProvider.of<CbLoginScreen>(context)
                                .state is StAuth,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // child: BlocBuilder<CbLoginScreen, StLoginScreen>(
                //   builder: (context, state){
                //     if(state is StLoginScreenLoading){
                //       return const Center(child: Loader(),);
                //     }
                //     if(state is StLoginScreenLoaded){
                //       return Container(color: Colors.green);
                //     }
                //     if(state is StLoginScreenError){
                //       return Container(color: Colors.red);
                //     }
                //     return Container(color: Colors.grey);
                //   },
                // ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
