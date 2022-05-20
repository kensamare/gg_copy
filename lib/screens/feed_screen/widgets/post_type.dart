import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/controllers/rx_badges.dart';
import 'package:gg_copy/project_widgets/text_icon_toggle.dart';
import 'package:gg_copy/project_widgets/text_toggle.dart';
import 'package:gg_copy/screens/feed_screen/feed_screen.dart';
import 'package:get/get.dart';


class PostType extends StatefulWidget {
  final Function(PostTypeValue select)? onChange;

  const PostType({this.onChange, Key? key}) : super(key: key);

  @override
  State<PostType> createState() => _PostTypeState();
}

class _PostTypeState extends State<PostType> {
  late RxBadges badgeController;
  List<Widget> item = [];

  @override
  void initState() {
    badgeController = Get.find(tag: "badge");
    super.initState();
  }

  
  final List<PostTypeItemViewModel> items = [
    PostTypeItemViewModel(
      rightMargin: 6, 
      text: "Теплое",
      toggleValues: PostTypeToggleValues(firstOptionValue: PostTypeValue.warm)
    ),
    PostTypeItemViewModel(
      rightMargin: 6,
      text: "Своё",
      toggleValues: PostTypeToggleValues(firstOptionValue: PostTypeValue.my, secondOptionValue: PostTypeValue.myFavorite),
      icon: Icons.star_border
    ),
    PostTypeItemViewModel(
      rightMargin: 12,
      text: "Неизведанное", 
      toggleValues: PostTypeToggleValues(firstOptionValue: PostTypeValue.all)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal, 
      itemBuilder: (context, index) {
        if (items[index].icon != null && items[index].toggleValues.secondOptionValue != null) {
            var state = TextIconToggleState.unselected;

            if(items[index].toggleValues.firstOptionValue == gSelect) {
                state = TextIconToggleState.selectedText;
            } else if(items[index].toggleValues.secondOptionValue == gSelect) {
                state = TextIconToggleState.selectedIcon;
            } 

            return TextIconToggle(
              text: items[index].text, 
              icon: items[index].icon, 
              stateChanged: (state) {
                var value = items[index].toggleValues.firstOptionValue;
                print(state);
                if(state == TextIconToggleState.selectedText) {
                    value = items[index].toggleValues.firstOptionValue;
                } else if(state == TextIconToggleState.selectedIcon) {
                    value = items[index].toggleValues.secondOptionValue ?? PostTypeValue.my;
                }

                if (gSelect != value) {
                  GetStorage().write('prevIndex', gSelect);
                  gSelect = value;
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                }

                setState(() {
                  
                });
              }, 
              state: state,
              isShowBadge: badgeController.countPosts.value != 0 && index == 1
            );
        }

        return TextToggle(text: items[index].text, isSelected: gSelect == items[index].toggleValues.firstOptionValue, onToggle: (isSelected) {
          setState(() {
              if (gSelect != items[index].toggleValues.firstOptionValue) {
                GetStorage().write('prevIndex', gSelect);
                gSelect = items[index].toggleValues.firstOptionValue;
                if (widget.onChange != null) {
                  widget.onChange!(items[index].toggleValues.firstOptionValue);
                }
              }
          });
        }, isShowBadge: badgeController.countPosts.value != 0 && index == 1);
    }, separatorBuilder: (context, index) {
        return SizedBox(width: items[index].rightMargin.w);
    }, itemCount: items.length,);
  }
}
/// Вспомогательные типы для компонента выбора типа поста 
enum PostTypeValue {
    warm, 
    my,
    myFavorite,
    all
}

class PostTypeToggleValues {
    final PostTypeValue firstOptionValue;
    final PostTypeValue? secondOptionValue;
    PostTypeToggleValues({required this.firstOptionValue, this.secondOptionValue});
}

class PostTypeItemViewModel {
    final String text;
    final int rightMargin;
    final IconData? icon;
    final PostTypeToggleValues toggleValues;

    const PostTypeItemViewModel({required this.text, required this.rightMargin, required this.toggleValues, this.icon});
}