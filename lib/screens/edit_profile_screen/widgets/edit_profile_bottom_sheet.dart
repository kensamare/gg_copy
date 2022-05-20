import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/screens/login_screen/login_screen_provider.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tr;
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../project_utils/controllers/rx_profile_edit.dart';
import '../../../project_utils/pj_icons.dart';
import '../../../project_utils/text_styles.dart';
import '../../setting_screen/setting_screen_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class EditProfileBottomSheet extends StatelessWidget {
  EditProfileBottomSheet({Key? key}) : super(key: key);

  RxProfileEdit editProfileController = Get.find(tag: "edit");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'выбрать из галереи',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () async {
                ImageSource source;
                PermissionStatus status = await Permission.storage.request();
                PermissionStatus statusPhoto = await Permission.photos.request();
                if ((status.isGranted || status.isLimited) && (statusPhoto.isGranted || statusPhoto.isLimited)) {
                  source = ImageSource.gallery;
                  XFile? file = await ImagePicker().pickImage(source: source);
                  String fileExtension = p.extension(file!.path).replaceAll('.', '');
                  if (fileExtension != 'gif' ||
                      fileExtension != 'jpeg' ||
                      fileExtension != 'jpg' ||
                      fileExtension != 'png' ||
                      fileExtension != 'heic') {
                    if (fileExtension == 'heic') {
                      print('convert to jpeg');
                      String? jpegPath = await HeicToJpg.convert(file.path);
                      file = XFile(jpegPath!);
                      fileExtension = 'jpeg';
                    }
                    editProfileController.file.value = file.path;
                  } else {
                    Get.dialog(
                      CupertinoAlertDialog(
                        title: const Text('Неподдерживаемый формат'),
                        content: const Text('Фото такого формата, мы пока что не поддерживаем!'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('Ок'),
                            isDestructiveAction: false,
                            onPressed: () {
                              Get.back();
                            },
                          )
                        ],
                      ),
                    );
                  }
                }
                Get.back();
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'сделать фото',
                  style: TextStyles.interMedium14,
                ),
              ),
              onPressed: () async {
                ImageSource source;
                PermissionStatus status = await Permission.storage.request();
                PermissionStatus statusPhoto = await Permission.photos.request();
                if ((status.isGranted || status.isLimited) && (statusPhoto.isGranted || statusPhoto.isLimited)) {
                  source = ImageSource.camera;
                  XFile? file = await ImagePicker().pickImage(source: source);
                  String fileExtension = p.extension(file!.path).replaceAll('.', '');
                  if (fileExtension == 'heic') {
                    print('convert to jpeg');
                    String? jpegPath = await HeicToJpg.convert(file.path);
                    file = XFile(jpegPath!);
                    fileExtension = 'jpeg';
                  }
                  if (file != null) editProfileController.file.value = file.path;
                }
                Get.back();
              },
            ),
            SizedBox(
              height: 10.w,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).canvasColor,
              child: Center(
                child: Text(
                  'удалить фото',
                  style: TextStyles.interMedium14Red,
                ),
              ),
              onPressed: () {
                editProfileController.file.value = "delete";
                Get.back();
              },
            ),
            SizedBox(
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
