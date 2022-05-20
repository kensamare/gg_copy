// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../data/registration.dart';
// import '../models/registration_model.dart';
//
// class RegistrationController extends GetxController {
//
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   var model = RegistrationModel().obs;
//   var widgetName = 'authorize'.obs;
//   String? token;
//
//   void goToWidget(String widget) {
//     widgetName.value = widget;
//   }
//
//   void _runFeedPage() async {
//     if (token != null) {
//       await Get.offAndToNamed('/feed-page', arguments: token,);
//     }
//     dispose();
//   }
//
//   void updateRegistrationData(
//     String username,
//     String email,
//     String password,
//     String repeatedPassword,
//   ) async {
//     if (password == repeatedPassword) {
//       model.update((value) {
//         value?.username = username;
//         value?.email = email;
//         value?.password = password;
//       });
//       token = await Registration.signUpRequest(
//         username,
//         email,
//         password,
//       );
//       final SharedPreferences prefs = await _prefs;
//       if (token !=null) {
//         await prefs.setString('token', token!);
//       }
//       _runFeedPage();
//     }
//   }
//
//   void updateLoginData(
//     String email,
//     String password,
//   ) async {
//     model.update((value) {
//       value?.email = email;
//       value?.password = password;
//     });
//     token = await Registration.signInRequest(
//       email,
//       password,
//     );
//     final SharedPreferences prefs = await _prefs;
//     if (token != null) {
//       await prefs.setString('token', token!);
//     }
//     _runFeedPage();
//   }
//
//   void getSavedToken() async {
//    if (token == null) {
//      final SharedPreferences prefs = await _prefs;
//      token = prefs.getString('token');
//      _runFeedPage();
//    }
//   }
// }
