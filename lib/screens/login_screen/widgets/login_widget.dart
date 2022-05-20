import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/custom_text_field.dart';
import 'package:gg_copy/screens/email_reset_screen/email_reset_screen_provider.dart';
import 'package:gg_copy/screens/login_screen/cubit/cb_login_screen.dart';

import '../../../../bloc_getx/controllers/registration_controller.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key, required this.errorAuth, required this.emailFocus, required this.passFocus}) : super(key: key);
  String errorAuth ;
  FocusNode emailFocus;
  FocusNode passFocus;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  // final _registrationController = Get.find<RegistrationController>();
  final emailFieldController = TextEditingController();

  final passwordFieldController = TextEditingController();

  String? emailText = '';

  String? passwordText = '';

  bool emailError = false;
  bool passError = false;

  @override
  Widget build(BuildContext context) {
    log(widget.errorAuth, name: 'BUILDERROR');
    if(widget.errorAuth != ''){
      emailError = true;
      passError = true;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44.w,
        ),
        Text(
          'вход',
          style: TextStyles.interMedium24,
        ),
        const SizedBox(
          height: 19,
        ),
        CustomTextField(
          hintText: 'почта или никнейм',
          controller: emailFieldController,
          focusNode: widget.emailFocus,
          errorIcon: emailError,
        ),
        if(emailText != '')...[
          Text(
            emailText!,
            style: TextStyles.interMedium14_808080,
          ),
        ],
        SizedBox(
          height: 10.w,
        ),
        CustomTextField(
          hintText: 'пароль',
          obscure: true,
          controller: passwordFieldController,
          focusNode: widget.passFocus,
          errorIcon: passError,
        ),
        Text(
          passwordText!,
          style: TextStyles.interMedium14_808080,
        ),
        Text(
          widget.errorAuth,
          style: TextStyles.interMedium14_808080,
        ),
        SizedBox(
          height: 30.w,
        ),
        SizedBox(
          width: double.infinity,
          height: 48.0.w,
          child: CupertinoButton(
            color: Theme.of(context).highlightColor,
            child: Text(
              'войти',
              style: TextStyles.interMedium14,
            ),
            onPressed: () {
              emailText = '';
              emailError = false;
              passwordText = '';
              passError = false;
              widget.errorAuth = '';
              if(emailFieldController.text.isEmpty || passwordFieldController.text.isEmpty){
                if(emailFieldController.text.isEmpty){
                  log(emailFieldController.text.isEmpty.toString(), name: 'NAME');
                  setState(() {
                    emailText = 'поле должно быть заполнено';
                    emailError = true;
                    widget.errorAuth = '';
                  });
                }else {
                  setState(() {
                    emailText = '';
                    emailError = false;
                  });
                }
                  if (passwordFieldController.text.isEmpty){
                    log(passwordFieldController.text.isEmpty.toString(), name: 'PASS');
                    setState(() {
                      passwordText = 'поле должно быть заполнено';
                      widget.errorAuth = '';
                      passError = true;
                    });
                }else{
                    setState(() {
                      passwordText = '';
                      passError = false;
                    });
                  }
              }else {
                BlocProvider.of<CbLoginScreen>(context).auth(
                    emailFieldController.text, passwordFieldController.text);
              }
              // _registrationController.updateLoginData(
              //   emailFieldController.text,
              //   passwordFieldController.text,
              // );
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 48.0.w,
          child: CupertinoButton(
            onPressed: () {
              Get.to(EmailResetScreenProvider());
            },
            child: Text(
              'забыли пароль?',
              style: TextStyles.interRegular14o40,
            ),
          ),
        ),
        SizedBox(
          height: 12.w,
        ),
      ],
    );
  }
}
