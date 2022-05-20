import 'dart:developer';

import 'st_edit_comment_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbEditCommentScreen extends Cubit<StEditCommentScreen> {
  CbEditCommentScreen() : super(StEditCommentScreenLoaded());
  
  Future<void> getData(int idPost,String text) async {
  try {
    emit(StEditCommentScreenLoading());
      Map<String, dynamic> response =
          await Api.put(method: 'posts/${idPost}', testMode: true, body: {'text': text}, isAuth: true);
      log(response.toString(), name: 'RESPONSE');
    } on APIException catch (e) {
    log(e.code.toString());
      emit(StEditCommentScreenError(error: e.code));
    }
  }
}
    