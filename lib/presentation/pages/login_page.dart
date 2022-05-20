// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:gg_copy/bloc_getx/controllers/registration_controller.dart';
// import 'package:gg_copy/presentation/widgets/login_page_widgets/change_widget_card.dart';
// import 'package:gg_copy/presentation/widgets/login_page_widgets/description_widget.dart';
//
// import '../../project_utils/text_styles.dart';
// import '../widgets/login_page_widgets/login_widget.dart';
// import '../widgets/login_page_widgets/sign_up_widget.dart';
//
// class LoginPage extends StatelessWidget {
//   LoginPage({Key? key}) : super(key: key);
//
//   final registrationController = Get.put(RegistrationController());
//
//   @override
//   Widget build(BuildContext context) {
//     registrationController.getSavedToken();
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'грустнограм',
//                   style: TextStyles.interMedium24,
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 Expanded(
//                   child: ListView(
//                     physics: const AlwaysScrollableScrollPhysics(
//                       parent: BouncingScrollPhysics(),
//                     ),
//                     children: [
//                       const DescriptionWidget(),
//                       Obx(() {
//                             if (registrationController.widgetName.value == 'authorize') {
//                               return LoginWidget();
//                             }
//                             if (registrationController.widgetName.value == 'registration') {
//                               return SignUpWidget();
//                             }
//                             return SignUpWidget();
//                           }
//                       ),
//                       Container(
//                         height: 1,
//                         color: const Color(0xFF2B2B2B),
//                       ),
//                       const SizedBox(
//                         height: 32.0,
//                       ),
//                       //ChangeWidgetCard(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
