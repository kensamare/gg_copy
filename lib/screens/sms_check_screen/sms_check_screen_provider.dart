import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sms_check_screen.dart';
import 'cubit/cb_sms_check_screen.dart';
import 'cubit/st_sms_check_screen.dart';

class SmsCheckScreenProvider extends StatelessWidget {
  final String? phone_key;
  SmsCheckScreenProvider({Key? key, required this.phone_key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbSmsCheckScreen>(
      create: (context) => CbSmsCheckScreen(),
      child:  SmsCheckScreen(phone_key: phone_key),
    );
  }
}    
    