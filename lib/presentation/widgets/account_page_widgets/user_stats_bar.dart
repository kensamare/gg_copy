import 'package:flutter/cupertino.dart';
import 'package:gg_copy/presentation/widgets/account_page_widgets/user_stats_element.dart';

class UserStatsBar extends StatelessWidget {
  const UserStatsBar({
    Key? key,
    required this.posts,
    required this.following,
    required this.followers,
  }) : super(key: key);
  final int posts;
  final int following;
  final int followers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 46.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: UserStatsElement(
                text: 'Публикации',
                value: posts,
              ),
            ),
            Expanded(
              child: UserStatsElement(
                text: 'Подписки',
                value: following,
              ),
            ),
            Expanded(
              child: UserStatsElement(
                text: 'Подписчики',
                value: followers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
