import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Feedback extends StatelessWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'наш телеграм',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () async {
                String url = 'https://t.me/grustnogram_official';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'info@grustnogram.ru',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'info@grustnogram.ru', //add subject and body here
                );
                var url = params.toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'сообщить об ошибке',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () async {
                String url = 'https://t.me/artman9k';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
