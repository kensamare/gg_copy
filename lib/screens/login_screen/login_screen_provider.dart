import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_screen.dart';
import 'cubit/cb_login_screen.dart';
import 'cubit/st_login_screen.dart';

class LoginScreenProvider extends StatelessWidget {
  const LoginScreenProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbLoginScreen>(
      create: (context) => CbLoginScreen(),
      child: const LoginScreen(),
    );
  }
}    
    