import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/login_screen/cubit/cb_login_screen.dart';
import 'package:gg_copy/screens/sms_check_screen/sms_check_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc_getx/controllers/registration_controller.dart';
import '../../../../project_widgets/custom_text_field.dart';

class SignUpWidget extends StatefulWidget {
  SignUpWidget(
      {Key? key,
      required this.errorList,
      required this.passFocus,
      required this.nameFocus,
      required this.repeatFocus,
      required this.emailFocus})
      : super(key: key);
  List<int> errorList = [];
  FocusNode nameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode repeatFocus = FocusNode();

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  // final _registrationController = Get.find<RegistrationController>();
  final usernameFieldController = TextEditingController();
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final repeatPasswordFieldController = TextEditingController();

  bool usernameError = false;
  bool emailError = false;
  bool passError = false;
  bool repeatPassError = false;
  String? usernameMessage = '';
  String? emailMessage = '';
  String? passMessage = '';
  bool isValid = true;
  String? repeatPassMessage = '';
  bool checkboxTap = false;
  bool activeB = true;
  final _emailExp = RegExp(
      r'^((([0-9A-Za-z]{1}[-0-9A-z\.]{0,30}[0-9A-Za-z]?)|([0-9А-Яа-я]{1}[-0-9А-я\.]{0,30}[0-9А-Яа-я]?))@([-A-Za-z]{1,}\.){1,}[-A-Za-z]{2,})$');

  @override
  Widget build(BuildContext context) {
    activeB = true;
    if (widget.errorList.contains(100)) {
      setState(() {
        emailMessage = 'такая почта уже есть в ситеме. грустно.';
        emailError = true;
      });
    }
    if (widget.errorList.contains(101)) {
      setState(() {
        usernameMessage = 'никнейм уже занят. грустно.';
        usernameError = true;
      });
    }
    if (widget.errorList.contains(111)) {
      setState(() {
        usernameMessage = 'Никнейм должен содержать латинские буквы, цифры, _ и точки, но не более двух подряд и без точки в начале';
        usernameError = true;
      });
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 44,
        ),
        Text(
          'регистрация аккаунта',
          style: TextStyles.interMedium24,
        ),
        const SizedBox(
          height: 19,
        ),
        CustomTextField(
          onEditingComplete: () {
            widget.nameFocus.nextFocus();
          },
          focusNode: widget.nameFocus,
          hintText: 'никнейм',
          controller: usernameFieldController,
          errorIcon: usernameError,
        ),
        if (usernameMessage != '') ...[
          Text(
            usernameMessage!,
            style: TextStyles.interMedium14_808080,
          ),
        ],
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          onEditingComplete: () {
            widget.emailFocus.nextFocus();
          },
          focusNode: widget.emailFocus,
          errorIcon: emailError,
          hintText: 'почта',
          controller: emailFieldController,
        ),
        if (emailMessage != '') ...[
          Text(
            emailMessage!,
            style: TextStyles.interMedium14_808080,
          ),
        ],
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          onEditingComplete: () {
            widget.passFocus.nextFocus();
          },
          focusNode: widget.passFocus,
          errorIcon: passError,
          hintText: 'пароль',
          obscure: true,
          controller: passwordFieldController,
        ),
        if (passMessage != '') ...[
          Text(
            passMessage!,
            style: TextStyles.interMedium14_808080,
          ),
        ],
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          focusNode: widget.repeatFocus,
          errorIcon: repeatPassError,
          hintText: 'повторите пароль',
          obscure: true,
          controller: repeatPasswordFieldController,
        ),
        if (repeatPassMessage != '') ...[
          Text(
            repeatPassMessage!,
            style: TextStyles.interMedium14_808080,
          ),
        ],
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          height: 48.0,
          child: CupertinoButton(
            color: Theme.of(context).highlightColor,
            onPressed: () {
              usernameError = false;
              emailError = false;
              passError = false;
              repeatPassError = false;
              usernameMessage = '';
              emailMessage = '';
              passMessage = '';
              repeatPassMessage = '';
              widget.errorList = [];

              if (checkboxTap == false) {
                setState(() {
                  isValid = false;
                });
              } else {
                setState(() {
                  isValid = true;
                });
              }
              if (usernameFieldController.text.isEmpty ||
                  emailFieldController.text.isEmpty ||
                  passwordFieldController.text.isEmpty ||
                  repeatPasswordFieldController.text.isEmpty) {
                if (usernameFieldController.text.isEmpty) {
                  setState(() {
                    usernameMessage = 'поле должно быть заполнено';
                    usernameError = true;
                  });
                } else {
                  setState(() {
                    usernameMessage = '';
                    usernameError = false;
                  });
                }
                if (emailFieldController.text.isEmpty) {
                  setState(() {
                    emailMessage = 'поле должно быть заполнено';
                    emailError = true;
                  });
                } else {
                  if (!_emailExp.hasMatch(emailFieldController.text)) {
                    setState(() {
                      emailMessage = 'неверный формат адреса';
                      emailError = true;
                    });
                  } else {
                    setState(() {
                      emailMessage = '';
                      emailError = false;
                    });
                  }
                }
                if (passwordFieldController.text.isEmpty) {
                  setState(() {
                    passMessage = 'поле должно быть заполнено';
                    passError = true;
                  });
                } else {
                  setState(() {
                    passMessage = '';
                    passError = false;
                  });
                }
                if (repeatPasswordFieldController.text.isEmpty) {
                  setState(() {
                    repeatPassMessage = 'поле должно быть заполнено';
                    repeatPassError = true;
                  });
                } else {
                  setState(() {
                    repeatPassMessage = '';
                    repeatPassError = false;
                  });
                }
              } else {
                if (!_emailExp.hasMatch(emailFieldController.text)) {
                  setState(() {
                    emailMessage = 'неверный формат адреса';
                    emailError = true;
                  });
                }
                if (passwordFieldController.text.length < 8) {
                  setState(() {
                    passMessage = 'пароль слишком легкий';
                    passError = true;
                  });
                } else if (repeatPasswordFieldController.text.isNotEmpty &&
                    repeatPasswordFieldController.text !=
                        passwordFieldController.text) {
                  setState(() {
                    repeatPassMessage = 'пароли не совпадают';
                    repeatPassError = true;
                  });
                } else if (_emailExp.hasMatch(emailFieldController.text) &&
                    passwordFieldController.text.length >= 8 &&
                    repeatPasswordFieldController.text.isNotEmpty &&
                    repeatPasswordFieldController.text ==
                        passwordFieldController.text &&
                    isValid) {
                  setState(() {
                    emailMessage = '';
                    emailError = false;
                    passMessage = '';
                    passError = false;
                    repeatPassMessage = '';
                    repeatPassError = false;
                  });
                  if (activeB){
                    BlocProvider.of<CbLoginScreen>(context).singUp(
                        usernameFieldController.text,
                        emailFieldController.text,
                        passwordFieldController.text);
                    activeB = false;
                  }

                }
              }
            },
            child: Text(
              'зарегистрироваться',
              style: TextStyles.interMedium14,
            ),
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  checkboxTap = !checkboxTap;
                });
              },
              child: Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: PjColors.background,
                  border: Border.all(
                      color: isValid ? PjColors.black2 : PjColors.red),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    PjIcons.checkBox,
                    color: checkboxTap ? PjColors.white : PjColors.black2,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunch('https://grustnogram.ru/legal')) {
                    await launch('https://grustnogram.ru/legal');
                  } else {
                    throw "Could not launch";
                  }
                },
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'я соглашаюсь с  ',
                    style: TextStyles.interRegular14o40,
                    children: [
                      TextSpan(
                        text: 'правилами пользования приложения',
                        style: TextStyle(
                            color: PjColors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0.w,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.w,
        ),
        if (!isValid) ...[
          Text(
            'чтобы зарегистрироваться, вам нужно подтвердить согласие с грустным документом',
            style: TextStyle(
                color: PjColors.textGrey,
                fontSize: 14,
                fontFamily: 'PjInter',
                fontWeight: FontWeight.w400),
          ),
        ],
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
