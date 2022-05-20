import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gg_copy/project_utils/singletons/sg_comments.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/screens/comment_screen/cubit/cb_comment_screen.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField(
      {Key? key,
      required this.postId,
      required this.index,
      this.isFromNotifications = false,
      this.sendComment,
      this.replyCommentFocusNode,
      this.controller})
      : super(key: key);

  final int postId;
  final int index;
  final bool isFromNotifications;
  final Future<void> Function(int, String, int)? sendComment;
  final FocusNode? replyCommentFocusNode;
  final TextEditingController? controller;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  // final postsActionsController = Get.find<PostsActionsController>();

  //final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0.w),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.replyCommentFocusNode,
        cursorColor: Colors.grey,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyles.interRegular14,
        onChanged: (text) {
          if (text == ''){
            SgComments.instance.setIdReply = -1;
            SgComments.instance.setIndexReply = -1;
            // GetStorage().write('idReply', null);
            // GetStorage().write('indexReply', null);
          }
        },
        maxLines: 7,
        minLines: 1,
        decoration: InputDecoration(
            suffix: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Text('Отправить'),
              onTap: () {
                if (widget.controller!.text.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  widget.isFromNotifications
                      ? widget.sendComment!(
                          widget.postId, widget.controller!.text, widget.index)
                      : BlocProvider.of<CbCommentScreen>(context).sendComment(
                          widget.postId,
                          widget.controller!.text,
                          0,
                          widget.index);
                  setState(() {
                    widget.controller!.text = '';
                  });
                }
              },
            ),
            filled: true,
            hintText: 'Добавить комментарий',
            hintStyle: TextStyles.interRegular14_808080,
            fillColor: Theme.of(context).hintColor,
            isCollapsed: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.0.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10.0.w,
              ),
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
