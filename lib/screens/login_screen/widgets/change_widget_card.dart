import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/login_screen/cubit/cb_login_screen.dart';

import '../../../../bloc_getx/controllers/registration_controller.dart';

class ChangeWidgetCard extends StatelessWidget {
  final bool isAuth;

  ChangeWidgetCard({Key? key, required this.isAuth}) : super(key: key);

  // final _registrationController = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        16.0.w,
      ),
      height: 128.0.w,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(
          10.0.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2.w,
          ),
          Text(
            !isAuth ? 'Есть аккаунт?' : 'Хотите создать новый профиль?',
            style: TextStyles.interMedium16,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: CupertinoButton(
              color: Theme.of(context).highlightColor,
              onPressed: () {
                BlocProvider.of<CbLoginScreen>(context).changeState(isAuth);
              },
              child: Text(
                !isAuth ? 'войти' : 'регистрация',
                style: TextStyles.interMedium14,
              ),
            ),
          ),
          SizedBox(
            height: 4.w,
          ),
        ],
      ),
    );
  }
}
