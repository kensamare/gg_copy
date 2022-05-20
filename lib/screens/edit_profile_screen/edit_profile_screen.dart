import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:gg_copy/screens/edit_profile_screen/widgets/edit_profile_bottom_sheet.dart';
import '../../models/self_model.dart';
import '../../project_utils/controllers/rx_menu_avatar.dart';
import '../../project_utils/controllers/rx_profile_edit.dart';
import '../../project_utils/controllers/rx_profile_reload.dart';
import '../../project_utils/text_styles.dart';
import '../../project_widgets/cupertino_app_bar.dart';
import '../../project_widgets/custom_text_field.dart';
import '../../project_widgets/error_widget.dart';
import 'cubit/cb_edit_profile_screen.dart';
import 'cubit/st_edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  SelfModel model;

  EditProfileScreen({Key? key, required this.model}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nicknameController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late RxProfileEdit editProfileController;
  late RxProfileReload reloadProfileController;

  @override
  void initState() {
    nicknameController = TextEditingController()..text = widget.model.nickname!;
    nameController = TextEditingController()..text = widget.model.name ?? "";
    descriptionController = TextEditingController()
      ..text = widget.model.about ?? "";

    editProfileController = Get.put(RxProfileEdit(), tag: "edit");
    reloadProfileController = Get.find(tag: "reload");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoAppBar(
        title: "Профиль",
        onBack: () {
          Get.back();
        },
        onSave: () {
          BlocProvider.of<CbEditProfileScreen>(context)
              .emit(StEditProfileScreenLoading());
        },
      ),
      body: BlocBuilder<CbEditProfileScreen, StEditProfileScreen>(
        builder: (context, state) {
          if (state is StEditProfileScreenInit) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 28.w),
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return EditProfileBottomSheet();
                      },
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100.w,
                          width: 100.w,
                          child: Obx(
                            () => editProfileController.file.value == ""
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.model.avatar100!),
                                  )
                                : editProfileController.file.value == "delete" ?
                            const CircleAvatar(
                              backgroundImage:
                              NetworkImage("https://560621.selcdn.ru/gg/empty_profile.jpg"),
                            ) :  ClipRRect(
                              borderRadius: BorderRadius.circular(100.w),
                                  child: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: FileImage(File(
                                            editProfileController.file.value)),
                                      ),
                                    ),
                                ),
                          ),
                        ),
                        SizedBox(height: 16.w),
                        Text("изменить фотографию",
                            style: TextStyles.interRegular14_808080),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.w),
                CustomTextField(
                  errorIcon: state.isErrorNickname,
                  hintText: 'никнейм',
                  controller: nicknameController,
                ),
                if (state.isErrorNickname) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      '${nicknameController.text} уже грустит с нами, выберите другой никнейм.',
                      style: TextStyles.interMedium14_808080,
                    ),
                  ),
                ],
                SizedBox(height: 10.w),
                CustomTextField(
                    errorIcon: false,
                    hintText: 'имя',
                    controller: nameController),
                SizedBox(height: 10.w),
                CustomTextField(
                  height: 111.0,
                    errorIcon: false,
                    hintText: 'описание',
                    maxLine: null,
                    minLine: null,
                    expands: true,
                    contentPaddingVertical: 10.0,
                    textAlignVertical: TextAlignVertical.top,
                    controller: descriptionController),
              ],
            );
          }
          if (state is StEditProfileScreenLoading) {
            BlocProvider.of<CbEditProfileScreen>(context).updateProfile(
                model: widget.model,
                nick: nicknameController.text,
                name: nameController.text,
                about: descriptionController.text,
                avatar: editProfileController.file.value == "delete" ? "" : editProfileController.file.value,
                deletePhoto: editProfileController.file.value == "delete");
            return const Center(
              child: Loader(),
            );
          }
          if (state is StEditProfileScreenLoaded) {
            reloadProfileController.setReload(true);
            WidgetsBinding.instance?.addPostFrameCallback((_){
              Get.back(result: true);
            });

            return Container();
          }
          if (state is StEditProfileScreenError) {
            return ErrWidget(errorCode: state.error.toString());
          }
          return Container(color: Colors.grey);
        },
      ),
    );
  }
}
