import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/custom_text_field.dart';
import 'package:gg_copy/screens/appeal_form_screen/widgets/reason_bottom_sheet.dart';
import 'package:gg_copy/screens/feed_screen/widgets/post_widgets/success_report_bottom_sheet.dart';

class AppealForm extends StatefulWidget {
  AppealForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AppealForm> createState() => _AppealFormState();
}

class _AppealFormState extends State<AppealForm> {
  final nameFieldController = TextEditingController();

  final emailFieldController = TextEditingController();

  final reasonFieldController = TextEditingController();

  final messageFieldController = TextEditingController();

  String? nameText = '';

  String? emailText = '';

  String? reasonText = '';

  String? messageText = '';

  bool nameError = false;
  bool emailError = false;
  bool reasonError = false;
  bool messageError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44.w,
        ),
        Text(
          'обратная связь',
          style: TextStyles.interMedium24,
        ),
        const SizedBox(
          height: 19,
        ),
        Text(
          'Если вам недостаточно грустно или грустно от ошибок и неполадок — напишите в форму ниже, мы разберемся',
          style: TextStyles.interRegular14_808080,
        ),
        const SizedBox(
          height: 19,
        ),
        CustomTextField(
          hintText: 'имя',
          controller: nameFieldController,
          errorIcon: nameError,
        ),
        if (nameText != '')
          Text(
            nameText!,
            style: TextStyles.interMedium14_808080,
          ),
        SizedBox(
          height: 10.w,
        ),
        CustomTextField(
          hintText: 'почта',
          controller: emailFieldController,
          errorIcon: emailError,
        ),
        if (emailText != '')
          Text(
            emailText!,
            style: TextStyles.interMedium14_808080,
          ),
        SizedBox(
          height: 10.w,
        ),
        GestureDetector(
          child: CustomTextField(
            hintText: 'что вы хотите',
            controller: reasonFieldController,
            errorIcon: false,
            arrowIcon: true,
            enabled: false,
          ),
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return ReasonBottomSheet(
                  controller: reasonFieldController,
                );
              },
            );
          },
        ),
        if (reasonText != '')
          Text(
            reasonText!,
            style: TextStyles.interMedium14_808080,
          ),
        SizedBox(
          height: 10.w,
        ),
        CustomTextField(
          hintText: 'сообщение',
          controller: messageFieldController,
          errorIcon: messageError,
        ),
        if (messageText != '')
          Text(
            messageText!,
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
              'отправить',
              style: TextStyles.interMedium14,
            ),
            onPressed: () {
              emailText = '';
              emailError = false;
              messageText = '';
              messageError = false;
              if (emailFieldController.text.isEmpty ||
                  messageFieldController.text.isEmpty ||
                  nameFieldController.text.isEmpty ||
                  reasonFieldController.text.isEmpty) {
                if (emailFieldController.text.isEmpty) {
                  setState(() {
                    emailText = 'поле должно быть заполнено';
                    emailError = true;
                  });
                } else {
                  setState(() {
                    emailText = '';
                    emailError = false;
                  });
                }
                if (messageFieldController.text.isEmpty) {
                  setState(() {
                    messageText = 'поле должно быть заполнено';
                    messageError = true;
                  });
                } else {
                  setState(() {
                    messageText = '';
                    messageError = false;
                  });
                }
                if (nameFieldController.text.isEmpty) {
                  setState(() {
                    nameText = 'поле должно быть заполнено';
                    nameError = true;
                  });
                } else {
                  setState(() {
                    nameText = '';
                    nameError = false;
                  });
                }
                if (reasonFieldController.text.isEmpty) {
                  setState(() {
                    reasonText = 'поле должно быть заполнено';
                    reasonError = true;
                  });
                } else {
                  setState(() {
                    reasonText = '';
                    reasonError = false;
                  });
                }
              } else {
                setState(() {
                  reasonText = '';
                  reasonError = false;
                  nameText = '';
                  nameError = false;
                  emailText = '';
                  emailError = false;
                  messageText = '';
                  messageError = false;
                });
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const SuccessReportBottomSheet(),
                );
                //TODO send request and return to main page
              }
            },
          ),
        ),
        SizedBox(
          height: 12.w,
        ),
      ],
    );
  }
}
