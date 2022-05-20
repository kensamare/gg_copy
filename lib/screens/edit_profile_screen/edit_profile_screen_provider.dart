import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/self_model.dart';
import 'edit_profile_screen.dart';
import 'cubit/cb_edit_profile_screen.dart';
import 'cubit/st_edit_profile_screen.dart';

class EditProfileScreenProvider extends StatelessWidget {
  SelfModel model;

  EditProfileScreenProvider({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbEditProfileScreen>(
      create: (context) => CbEditProfileScreen(),
      child: EditProfileScreen(model: model),
    );
  }
}    
    