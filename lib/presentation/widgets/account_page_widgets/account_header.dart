import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gg_copy/bloc_getx/controllers/posts_actions_conttroller.dart';

import '../../../project_utils/text_styles.dart';

class AccountHeader extends StatefulWidget {
  AccountHeader({
    Key? key,
    this.imageUrl,
    this.nickname,
    this.name,
    this.description,
    required this.canFollow,
    required this.id,
  }) : super(key: key);
  final String? imageUrl;
  final String? nickname;
  final String? name;
  final String? description;
  final dynamic id;
  final bool canFollow;

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  bool canFollow = true;

  @override
  void initState() {
    canFollow = widget.canFollow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.imageUrl != null
              ? CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(widget.imageUrl!),
          )
              : const CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.nickname ?? '',
            style: TextStyles.interMedium30,
          ),
          if (widget.name != null && widget.name!.isNotEmpty)
            const SizedBox(
              height: 12,
            ),
          Text(
            widget.name ?? '',
            style: TextStyles.interSemiBold16,
          ),
          if (widget.description != null && widget.description!.isNotEmpty)
            const SizedBox(
              height: 6,
            ),
          Text(
            widget.description ?? '',
            style: TextStyles.interRegular14o70,
          ),
          if (widget.description != null && widget.description!.isNotEmpty)
            const SizedBox(
              height: 16,
            ),
          Container(
            width: 312,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: CupertinoButton(
              color:
              Theme
                  .of(context)
                  .hintColor,
              onPressed: () {
                // if (widget.nickname !=
                //     postsActionsController.mySelfData?['nickname']) {
                //   if (canFollow) {
                //     postsActionsController.followAccount(widget.id);
                //   } else {
                //     postsActionsController.unfollowAccount(widget.id);
                //   }
                //   setState(() {
                //     canFollow = !canFollow;
                //   });
                // }
              },
              child: Text(
                //widget.nickname ==
                    // postsActionsController.mySelfData?['nickname']
                    // ?
                    'Редактировать профиль',
                //   : (canFollow ? 'Подписаться' : 'Отписаться'),
                style: TextStyles.interRegular14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
