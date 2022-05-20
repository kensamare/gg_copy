import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_create_screen.dart';
import 'cubit/cb_post_create_screen.dart';
import 'cubit/st_post_create_screen.dart';

class PostCreateScreenProvider extends StatelessWidget {
  PostCreateScreenProvider({Key? key, this.isProfile = false}) : super(key: key);

  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbPostCreateScreen>(
      create: (context) => CbPostCreateScreen(isProfile),
      child: const PostCreateScreen(),
    );
  }
}    
    