import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gg_copy/screens/favorites_screen/cubit/cb_favorites_screen.dart';
import 'package:gg_copy/screens/favorites_screen/favorites_screen.dart';

class FavoritesScreenProvider extends StatelessWidget {
  const FavoritesScreenProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CbFavoritesScreen>(
      create: (context) => CbFavoritesScreen(),
      child: const FavoritesScreen(),
    );
  }
}
