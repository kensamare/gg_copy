import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_list_screen.dart';
import 'cubit/cb_user_list_screen.dart';
import 'cubit/st_user_list_screen.dart';

class UserListScreenProvider extends StatelessWidget {
  // если true то будет выведен список подписчиков, если false то подписок
 final  bool isFollowers;
 final  String id;
  const UserListScreenProvider({Key? key, required this.id, required this.isFollowers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbUserListScreen>(
      create: (context) => CbUserListScreen(),
      child:  UserListScreen(id: id, isFollowers: isFollowers,),
    );
  }
}    
    