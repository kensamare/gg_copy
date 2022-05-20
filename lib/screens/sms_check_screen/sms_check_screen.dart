import 'dart:async';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';

// import 'package:gg_copy/project_utils/pj_utils.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../project_utils/text_styles.dart';
import 'cubit/cb_sms_check_screen.dart';
import 'cubit/st_sms_check_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmsCheckScreen extends StatefulWidget {
  final String? phone_key;

  const SmsCheckScreen({Key? key, required this.phone_key}) : super(key: key);

  @override
  _SmsCheckScreenState createState() => _SmsCheckScreenState();
}

class _SmsCheckScreenState extends State<SmsCheckScreen> {
  String? phone = '';
  late TextEditingController phoneController;
  late TextEditingController codeController;
  final formKey = GlobalKey<FormState>();
  late Timer _timer;
  int _start = 60;
  bool smsCheck = false;
  FocusNode _phoneFocus = FocusNode();
  FocusNode _codeFocus = FocusNode();
  String errorMessage = '';
  bool isTrueNumber = false;


  @override
  void initState() {
    phoneController = TextEditingController();
    codeController = TextEditingController();
    phoneController.addListener(() {
      if (phoneController.text.length > 8) {
        setState(() {
          isTrueNumber = true;
        });
      } else {
        setState(() {
          isTrueNumber = false;
        });
      }
    });
    super.initState();
  }

//
  @override
  void dispose() {
    codeController.dispose();
    phoneController.dispose();
    _phoneFocus.dispose();
    _codeFocus.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _phoneFocus.unfocus();
        _codeFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: PjColors.background,
        appBar: PjAppBar(
          leading: !smsCheck,
          onBack: () {
            Get.offAll(LoginScreenProvider());
          },
        ),
        body: BlocConsumer<CbSmsCheckScreen, StSmsCheckScreen>(
          buildWhen: (prevState, curState) {
            print(curState);
            if (curState is StSmsCheckScreenEnterCode) {
              return true;
            } else if (curState is StSmsCheckScreenLoaded) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state is StSmsCheckScreenEnterCode) {
              smsCheck = true;
            }
            if (state is StSmsCheckScreenLogin) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              GetStorage().remove('phone_key');
              Get.offAll(() => NavigationScreen());
            }
            if (state is StSmsCheckScreenEnterCode) {
              startTimer();
            }
            if (state is StSmsCheckScreenLoading) {
              Get.dialog(Center(child: CupertinoActivityIndicator()),
                  barrierColor: Colors.white.withOpacity(0.3));
            }
            if (state is StSmsCheckScreenError) {}
          },
          builder: (context, state) {
            if (state is StSmsCheckScreenLoaded) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50.w,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Get.back();
                          //   },
                          //   child: Row(
                          //     children: [
                          //       SvgPicture.asset(PjIcons.arrowLeft),
                          //       Text(
                          //         'Вернуться',
                          //         style: TextStyles.interRegular14_808080,
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 14.w,
                          ),
                          Text(
                            'небольшая проверка',
                            style: TextStyles.interMedium20,
                          ),
                          SizedBox(
                            height: 16.w,
                          ),
                          TextField(
                              keyboardType: TextInputType.phone,
                              focusNode: _phoneFocus,
                              controller: phoneController,
                              inputFormatters: [
                                TextInputMask(mask: ['\\+9 9999999999999999']),
                              ],
                              cursorColor: Colors.grey,
                              style: TextStyles.interRegular14,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'телефон',
                                hintStyle: TextStyles.interRegular14_808080,
                                fillColor: Theme.of(context).hintColor,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              )),
                          SizedBox(
                            height: 10.w,
                          ),
                          Text(
                            'Нам нужно убедиться, что вы человек. Введите \nваш номер телефона, наш печальный робот\nпозвонит вам, запишите последние 4 цифры\nномера, с которого поступит звонок.',
                            style: TextStyles.interRegular14_808080,
                          ),
                          SizedBox(
                            height: 24.w,
                          ),
                          Text(
                            'Ваш номер не будет привязан к профилю',
                            style: TextStyles.interSemiBold14,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 61.w, top: 60.w),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48.0,
                          child: GestureDetector(
                            onTap: () {
                              if (phoneController.text.length > 8) {
                                phone = phoneController.text;
                                BlocProvider.of<CbSmsCheckScreen>(context)
                                    .send_sms(
                                        phone_key: widget.phone_key!,
                                        phone_number: phone!);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48.0,
                              decoration: BoxDecoration(
                                  border: isTrueNumber
                                      ? null
                                      : Border.all(color: PjColors.black53),
                                  color: isTrueNumber
                                      ? Theme.of(context).highlightColor
                                      : PjColors.background,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0.w)),
                                  shape: BoxShape.rectangle),
                              child: Center(
                                child: Text(
                                  'продолжить',
                                  style: TextStyle(
                                      fontFamily: 'PjInter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.w,
                                      color: isTrueNumber
                                          ? PjColors.white
                                          : PjColors.textGrey),
                                ),
                              ),
                            ),
                          ),
                          // CupertinoButton(
                          //   color: phoneController.text.length == 13 ? Theme.of(context).highlightColor : PjColors.background,
                          //   onPressed: () {
                          //     if (phoneController.text.length == 13) {
                          //       phone = phoneController.text;
                          //       BlocProvider.of<CbSmsCheckScreen>(context)
                          //           .send_sms(
                          //           phone_key: widget.phone_key!,
                          //           phone_number: phone!);
                          //     }
                          //   },
                          //   child: Text(
                          //     'продолжить',
                          //     style: TextStyles.interMedium14,
                          //   ),
                          // ),
                        ),
                      )
                    ]),
              );
            }
            if (state is StSmsCheckScreenError) {
              return Container(color: Colors.red);
            }
            if (state is StSmsCheckScreenEnterCode) {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  smsCheck = false;
                                });
                                _timer.cancel();
                                BlocProvider.of<CbSmsCheckScreen>(context)
                                    .emit(StSmsCheckScreenLoaded());
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(PjIcons.arrowLeft),
                                  Text(
                                    'Вернуться',
                                    style: TextStyles.interRegular14_808080,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.w,
                            ),
                            Text(
                              '$phone',
                              style: TextStyles.interMedium20,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Text(
                              'Введите последние 4 цифры номера,\nс которого поступил звонок',
                              style: TextStyles.interRegular14_808080,
                            ),
                            SizedBox(
                              height: 14.w,
                            ),
                            Form(
                              key: formKey,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: PjColors.blackAnother,
                                      borderRadius:
                                          BorderRadius.circular(10.w)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30.w, horizontal: 18.w),
                                  child: PinCodeTextField(
                                    autoDisposeControllers: false,
                                    focusNode: _codeFocus,
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: PjColors.white,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 74.w,
                                    ),
                                    length: 4,
                                    textStyle: TextStyle(
                                      color: PjColors.white,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 74.w,
                                    ),
                                    showCursor: false,
                                    // obscuringWidget: const FlutterLogo(
                                    //   size: 24,
                                    // ),
                                    // blinkWhenObscuring: true,
                                    // animationType: AnimationType.fade,

                                    pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.underline,
                                        borderRadius: BorderRadius.circular(5),
                                        fieldHeight: 93.w,
                                        fieldWidth: 70.w,
                                        activeFillColor: PjColors.white,
                                        activeColor: PjColors.grey3,
                                        disabledColor: PjColors.grey3,
                                        inactiveColor: PjColors.grey3,
                                        selectedColor: PjColors.white),
                                    cursorColor: Colors.black,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    // enableActiveFill: true,
                                    // errorAnimationController: errorController,
                                    controller: codeController,
                                    keyboardType: TextInputType.number,
                                    // boxShadows: const [
                                    //   BoxShadow(
                                    //     offset: Offset(0, 1),
                                    //     color: Colors.black12,
                                    //     blurRadius: 10,
                                    //   )
                                    // ],
                                    onCompleted: (v) {
                                      debugPrint("Completed");
                                    },
                                    // onTap: () {
                                    //   print("Pressed");
                                    // },
                                    // onChanged: (value) {
                                    //   debugPrint(value);
                                    //   setState(() {
                                    //     currentText = value;
                                    //   });
                                    // },
                                    beforeTextPaste: (text) {
                                      debugPrint("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                    onChanged: (String value) {},
                                  )),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              child: Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_start == 0) {
                                      BlocProvider.of<CbSmsCheckScreen>(context)
                                          .send_sms(
                                              phone_key: widget.phone_key!,
                                              phone_number: phone!);

                                      //   startTimer();
                                    }
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Text('Запросить код повторно',
                                      style: TextStyle(
                                          fontFamily: 'PjInter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0.w,
                                          color: PjColors.white,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            if (_start != 0) ...[
                              Text(
                                'Повторный запрос через $_start сек.',
                                style: TextStyles.interRegular14_808080,
                              ),
                            ],
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 61.w),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48.0,
                            child: CupertinoButton(
                              disabledColor:
                                  CupertinoColors.quaternarySystemFill,
                              color: Theme.of(context).highlightColor,
                              onPressed: () {
                                if (_isActiveMainButton()) {
                                  BlocProvider.of<CbSmsCheckScreen>(context)
                                      .getData(
                                          phone: phone!,
                                          code: codeController.text);
                                }
                              },
                              child: Text(
                                'продолжить',
                                style: TextStyles.interMedium14,
                              ),
                            ),
                          ),
                        )
                      ]));
            }
            return Container(color: Colors.grey);
          },
        ),
      ),
    );
  }

  bool _isActiveMainButton() {
    if (codeController.text.length < 4) {
      return false;
    } else {
      return true;
    }
  }

  void startTimer() {
    _start = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start == 0) {
                _timer.cancel();
              } else {
                print(_start.toString());
                _start = _start - 1;
              }
            }));
  }

// String outputTimer() {
//   String secondsRow;
//   int minutes = 0;
//   int seconds = _start;
//   if(_start >= 60){
//     minutes = _start~/60.0;
//     seconds -= minutes*60;
//   }
//   if(seconds < 10){
//     secondsRow ='0$seconds';
//   } else {
//     secondsRow ='$seconds';
//   }
//   return '$minutes:$secondsRow';
// }

}
