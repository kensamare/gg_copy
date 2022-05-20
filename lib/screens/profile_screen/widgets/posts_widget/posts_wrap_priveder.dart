import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gg_copy/models/self_model.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/cubit/cb_posts.dart';
import 'package:gg_copy/screens/profile_screen/widgets/posts_widget/posts_wrap.dart';

class PostsWrapProvider extends StatelessWidget {
  SelfModel user;

   PostsWrapProvider({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbPosts>(
      create: (context) => CbPosts(),
      child: PostsWrap(user: user,)
    );
  }
}
