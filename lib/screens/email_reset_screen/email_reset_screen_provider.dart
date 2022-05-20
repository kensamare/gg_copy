import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_reset_screen.dart';
import 'cubit/cb_email_reset_screen.dart';
import 'cubit/st_email_reset_screen.dart';

class EmailResetScreenProvider extends StatelessWidget {
  const EmailResetScreenProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbEmailResetScreen>(
      create: (context) => CbEmailResetScreen(),
      child: const EmailResetScreen(),
    );
  }
}    
    