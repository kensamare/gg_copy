import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../project_utils/text_styles.dart';
import '../../project_widgets/error_widget.dart';
import '../../project_widgets/loader.dart';
import '../feed_screen/controllers/post_controller.dart';
import 'cubit/cb_edit_comment_screen.dart';
import 'cubit/st_edit_comment_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCommentScreen extends StatefulWidget {
  final int idPost;
  final String tag;
  final int idEditPost;

  const EditCommentScreen(
      {Key? key,
      required this.idPost,
      required this.tag,
      required this.idEditPost})
      : super(key: key);

  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  late PostController _postController;
  TextEditingController controllerDescription = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  void initState() {
    _postController = Get.find(tag: widget.tag);
    controllerDescription.text = _postController.posts[widget.idEditPost].text!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focus.unfocus();
      },
      child: Scaffold(
        appBar: PjAppBar(
          color: Colors.black,
          title: '',
          bottomLine: false,
          leading: true,
          notBack: true,
          onBack: () {
            Get.back();
          },
          action: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await BlocProvider.of<CbEditCommentScreen>(context)
                  .getData(widget.idPost, controllerDescription.text);
              _postController.updateTextPost(widget.idEditPost, controllerDescription.text);
              Get.back(result: true);
            },
            child: Container(
              padding: EdgeInsets.all(14.w),
              child: Text(
                'Сохранить',
                style: TextStyles.interRegular14.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        body: BlocBuilder<CbEditCommentScreen, StEditCommentScreen>(
          builder: (context, state) {
            if (state is StEditCommentScreenLoading) {
              return const Center(
                child: Loader(),
              );
            }
            if (state is StEditCommentScreenLoaded) {
              log(_postController.posts[widget.idEditPost].toString(),
                  name: 'IDDDDD');
              // log(_postController.posts[].text.toString(), name: 'DESCRIPTIONN');
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.w),
                            child: Image.network(_postController
                                .posts[widget.idEditPost].media![0],
                            loadingBuilder: (context, widget, event) {
                              if (event == null)
                                return widget;
                              return const Center(
                                child: Loader(),
                              );
                            },
                            )),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      TextField(
                        controller: controllerDescription,
                        focusNode: focus,
                        cursorColor: Colors.grey,
                        style: TextStyles.interRegular14,
                        maxLines: 7,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Добавить комментарий',
                            hintStyle: TextStyles.interRegular14_808080,
                            fillColor: Theme.of(context).hintColor,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.0.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10.0.w,
                              ),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is StEditCommentScreenError) {
              return ErrWidget(errorCode: state.error.toString());
            }
            return Container(color: Colors.grey);
          },
        ),
      ),
    );
  }
}
