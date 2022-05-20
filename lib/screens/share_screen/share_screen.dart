import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_copy/project_utils/singletons/sg_user.dart';
import 'package:gg_copy/project_widgets/pj_button.dart';
import 'package:gg_copy/screens/share_screen/widgets/image_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:share_plus/share_plus.dart';

import '../../project_utils/text_styles.dart';
import 'dart:ui' as ui;

class ShareScreen extends StatefulWidget {
  final String nickname;
  ShareScreen({Key? key, this.nickname = ''}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final GlobalKey _globalKey = GlobalKey();
  late bool isShare;
  late String nickname;

  @override
  void initState() {
    isShare = false;
    if(widget.nickname.isNotEmpty){
      nickname = widget.nickname;
    } else{
      nickname = SgUser.instance.user.nickname!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImageShare(
                gKey: _globalKey,
                nickname: nickname,
                isShare: true,
              ),
              PjButton(
                  label: "Поделиться обложкой",
                  color: Color(0xFF1C1C1C),
                  onPresser: _capturePng),
              SizedBox(
                height: 8.w,
              ),
              PjButton(
                  label: "Поделиться ссылкой",
                  color: Color(0xFF1C1C1C),
                  onPresser: () {
                    // HapticFeedback.heavyImpact();
                    _saveLink();
                  }),
              SizedBox(
                height: 15.w,
              ),
              // Container(
              //   width: 300.w,
              //   child: Text(
              //       "Позовите своих друзей и знакомых, вместе не так грустно",
              //       style: TextStyles.interMedium16_808080,
              //   textAlign: TextAlign.center,),
              // ),
              SizedBox(
                height: 15.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveLink() {
    Share.share("https://grustnogram.ru/u/$nickname");
    // Clipboard.setData(ClipboardData(
    //     text: "https://grustnogram.ru/u/${SgUser.instance.user.nickname}"));
  }

  Future<void> _capturePng() async {
    // try {

    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/self.png'; // 3
    File file = File(filePath);
    var a = List<int>.from(pngBytes!);
    await file.writeAsBytes(a);

    Share.shareFiles([filePath]);

    // } catch (e) {
    //   print(e);
    // }
  }
}
