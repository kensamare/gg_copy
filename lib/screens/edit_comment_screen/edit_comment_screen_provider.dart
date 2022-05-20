import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_comment_screen.dart';
import 'cubit/cb_edit_comment_screen.dart';
import 'cubit/st_edit_comment_screen.dart';

class EditCommentScreenProvider extends StatelessWidget {
  final int idEditPost;
  final int idPost;
  final String tag;
  const EditCommentScreenProvider({Key? key, required this.idPost, required this.tag, required this.idEditPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbEditCommentScreen>(
      create: (context) => CbEditCommentScreen(),
      child: EditCommentScreen(idPost: idPost, tag: tag, idEditPost: idEditPost,),
    );
  }
}    
    