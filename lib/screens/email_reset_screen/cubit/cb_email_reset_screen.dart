import 'dart:developer';

import 'st_email_reset_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticon_api/eticon_api.dart';

class CbEmailResetScreen extends Cubit<StEmailResetScreen> {
  CbEmailResetScreen() : super(StEmailResetScreenLoaded());
  
  Future<void> getData({required String email}) async {
  try {
    emit(StEmailResetScreenLoading());
      Map<String, dynamic> response =
          await Api.post(method: 'respsswd', testMode: true, body: {
            "email": email
          });

      if(response['err'].contains(4)){
        emit(StEmailResetScreenError(error: 4));
      }else{
        emit(StEmailResetScreenComplete());
      }
    } on APIException catch (e) {
      emit(StEmailResetScreenError(error: e.code, message: e.body));
    } on StateError catch(e){
    log('SKIP');
  }
  }
}
    