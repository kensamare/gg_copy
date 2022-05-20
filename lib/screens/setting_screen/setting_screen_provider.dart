import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_screen.dart';
import 'cubit/cb_setting_screen.dart';
import 'cubit/st_setting_screen.dart';

class SettingScreenProvider extends StatelessWidget {
  const SettingScreenProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbSettingScreen>(
      create: (context) => CbSettingScreen(),
      child:  SettingScreen(),
    );
  }
}    
    