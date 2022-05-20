import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../project_utils/text_styles.dart';
import '../cubit/cb_search_screen.dart';

class SearchField extends StatelessWidget {
  final String search;
  SearchField({Key? key, this.search = ''}) : super(key: key){
    _controller = TextEditingController(text: search);
  }

  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Container(
        height: 37.w,
        child: TextField(
          controller: _controller,
          onSubmitted: (value){
            if(value.isNotEmpty){
              BlocProvider.of<CbSearchScreen>(context).getData(value);
            }else{
              BlocProvider.of<CbSearchScreen>(context).getTopData();
            }
          },
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "поиск грустных соотечественников",
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14.0.w,
              color: const Color(0xFF808080),
            ),
            contentPadding: EdgeInsets.only(
              bottom: 37.w / 2, // HERE THE IMPORTANT PART
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(10.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(10.w),
            ),
          ),
        ),
      ),
    );
  }
}
