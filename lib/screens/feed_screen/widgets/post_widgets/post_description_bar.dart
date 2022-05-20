import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:gg_copy/project_widgets/parsed_text/flutter_parsed_text.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:gg_copy/screens/search_screen/search_screen_provider.dart';

class PostDescriptionBar extends StatefulWidget {
  const PostDescriptionBar({
    Key? key,
    required this.username,
    required this.description,
    required this.links,
    required this.tag,
    this.showFullDescription = false,
  }) : super(key: key);

  final String username;
  final String description;
  final bool showFullDescription;
  final List<String> links;
  final String tag;

  @override
  State<PostDescriptionBar> createState() => _PostDescriptionBarState();
}

class _PostDescriptionBarState extends State<PostDescriptionBar> {
  bool showDescription = false;
  bool firstRun = true;
  late PostController controller;

  @override
  initState() {
    controller = Get.find(tag: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      showDescription = widget.showFullDescription;
      firstRun = false;
    }
    if (widget.description.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 12.0.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
            // child: RichText(
            //   text: TextSpan(
            //     text: '${widget.username} ',
            //     style: TextStyles.interSemiBold14,
            //     recognizer: TapGestureRecognizer()
            //       ..onTap = () {
            //         if (SgUser.instance.user.nickname == widget.username) {
            //           navigateToNav(initIndex: 4);
            //           // Get.offAll(() => NavigationScreen(
            //           //       init: 4,
            //           //     ));
            //           return;
            //         }
            //         Get.to(() => ProfileScreenProvider(nickname: widget.username), transition: tr.Transition.cupertino)
            //             ?.then((value) {
            //           controller.updateAllTags();
            //         });
            //       },
            //     children: generateList(),
            //   ),
            // ),
            child: ParsedText(
              text: widget.description,
              nickName: widget.username,
              style: TextStyles.interRegular14o70,
              onBack: () {
                controller.updateAllTags();
              },
              showFull: false,
              parse: [
                for (String link in widget.links)
                  MatchText(
                      pattern: link,
                      style: TextStyles.interSemiBold14,
                      onTap: (nickname) {
                        if (SgUser.instance.user.nickname == link.replaceAll("@", "")) {
                          navigateToNav(initIndex: 4);
                          return;
                        }
                        Get.to(() => ProfileScreenProvider(nickname: link.replaceAll("@", "").replaceAll("\n", "")),
                                transition: tr.Transition.cupertino)
                            ?.then((value) {
                          {
                            controller.updateAllTags();
                          }
                        });
                      }),
                MatchText(
                    pattern: r'\B#+([^\x00-\x7F]|\w)+',
                    style: TextStyles.interSemiBold14,
                    onTap: (value) {
                      Get.to(
                              () => SearchScreenProvider(
                                    search: value,
                                  ),
                              transition: Transition.cupertino)
                          ?.then((value) {
                        {
                          controller.updateAllTags();
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  List<TextSpan> generateList() {
    ///Старый вариант
    log(widget.links.toString(), name: 'LINKS');
    print("============ Наш маленьий секрет =========");
    List<TextSpan> lst = [];
    List<String> txt = widget.description.replaceAll("@", " @").split(" ");
    int len = 0;

    if (txt.length == 0) {
      return lst;
    }

    for (int i = 0; i < txt.length; i++) {
      try {
        len += txt[i].length;
        if (len > 60 && !showDescription) {
          break;
        }
        if (txt[i][0] == "@") {
          lst.add(TextSpan(
            text: txt[i] + " ",
            style: TextStyles.interSemiBold14,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (SgUser.instance.user.nickname == txt[i].replaceAll("@", "")) {
                  navigateToNav(initIndex: 4);
                  return;
                }
                Get.to(() => ProfileScreenProvider(nickname: txt[i].replaceAll("@", "").replaceAll("\n", "")),
                        transition: tr.Transition.cupertino)
                    ?.then((value) {
                  {
                    controller.updateAllTags();
                  }
                });
              },
          ));
        } else {
          lst.add(TextSpan(
            text: txt[i] + " ",
            style: TextStyles.interRegular14o70,
          ));
        }
      } catch (e) {}
    }

    if (!showDescription && len >= 60) {
      lst.add(
        TextSpan(
          text: '  ещё',
          style: TextStyles.interRegular14_808080,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                showDescription = !showDescription;
              });
            },
        ),
      );
    }
    return lst;
  }
}
