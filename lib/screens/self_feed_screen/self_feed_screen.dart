import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cubit/cb_self_feed_screen.dart';
import 'cubit/st_self_feed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
      

class SelfFeedScreen extends StatelessWidget {
  const SelfFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PjAppBar(),
      body: BlocBuilder<CbSelfFeedScreen, StSelfFeedScreen>(
        builder: (context, state){
          if(state is StSelfFeedScreenLoading){
            return const Center(child: Loader(),);
          }
          if(state is StSelfFeedScreenLoaded){
            return Container(color: Colors.green);
          }
          if(state is StSelfFeedScreenError){
            return Container(color: Colors.red);
          }
          return Container(color: Colors.grey);
        },
      ),
    );
      
  }
}
    