library flutter_parsed_text;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:emoji_regex/emoji_regex.dart';

part 'parsed_text.dart';
part 'regex_options.dart';
part 'match_text.dart';
part 'constants.dart';
