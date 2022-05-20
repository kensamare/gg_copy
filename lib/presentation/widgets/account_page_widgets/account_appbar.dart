import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../project_widgets/custom_app_bar.dart';

class AccountAppBar extends CustomAppBar {
  const AccountAppBar({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  String get name => username;

  @override
  Widget? get thirdIcon => null;
}
