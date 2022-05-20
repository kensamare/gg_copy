import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_screen.dart';
import 'cubit/cb_search_screen.dart';
import 'cubit/st_search_screen.dart';

class SearchScreenProvider extends StatelessWidget {
  final String search;
  const SearchScreenProvider({Key? key, this.search = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbSearchScreen>(
      create: (context) => CbSearchScreen(),
      child:  SearchScreen(search: search,),
    );
  }
}    
    