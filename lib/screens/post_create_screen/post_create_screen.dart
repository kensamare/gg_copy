import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gg_copy/presentation/app.dart';
import 'package:gg_copy/project_utils/pj_colors.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_utils/text_styles.dart';
import 'package:gg_copy/project_widgets/custom_text_field.dart';
import 'package:gg_copy/project_widgets/error_widget.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:gg_copy/project_widgets/pj_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/post_create_screen/gallery_view.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart' as f;
import 'package:image_size_getter/image_size_getter.dart' as sg;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'cubit/cb_post_create_screen.dart';
import 'cubit/st_post_create_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:path/path.dart' as p;

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({Key? key}) : super(key: key);

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> with TickerProviderStateMixin {
  File currentImage = File('');
  Uint8List data = Uint8List(0);
  ui.Image? _uiImage;
  img.Image? image;
  img.Image? res;
  GifData? gif;
  Uint8List imageData = Uint8List(0);
  Uint8List gifData = Uint8List(0);
  Rx<Offset> last = Offset(100, 100).obs;
  Rx<Offset> current = Offset(100, 100).obs;
  bool zoom = false;

  @override
  initState() {
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.addListener(() {
      if(_controller.value.row0[0] != 1.0 && !zoom){
        setState(() {
          zoom = true;
        });
      } else if(_controller.value.row0[0] == 1.0 && zoom){
        setState(() {
          zoom = false;
        });
      }
      // double scale = _controller.value.row0[0];
      // double width = scale * oldSize!.width;
      // double height = scale * oldSize!.height;
      // RenderBox box = widgetKey.currentContext!.findRenderObject() as RenderBox;
      // Offset position = box.localToGlobal(Offset.zero); //this is global position
      // last.value = current.value;
      // current.value = position;
      // gridSize.value = Size(width > 375.w ? 375.w : width, height > 400.w ? 400.w : height);
      // double border = (375.w - oldSize!.width)/2;
      // double offset = border*scale + oldSize!.width * scale - 375.w;
      // log(offset.toString(), name: 'qwe');
      // log(_controller.value.row1[3].toString(), name: 'df');
      // log((border*scale).toString());
      // _animateResetInitialize();
    });
    super.initState();
  }

  TransformationController _controller = TransformationController();

  Animation<Matrix4>? _animationReset;
  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _controller.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    double border = (375.w - oldSize!.width) / 2;
    double scale = _controller.value.row0[0];
    Matrix4 end = _controller.value.clone();
    double mainOffset = _controller.value.row0[3];
    if (scale == 1.0) {
      end = Matrix4.identity();
    } else if (scale * oldSize!.width < 375.w) {
      double smallBorder = (375.w - oldSize!.width * scale) / 2;
      end.row0 = v.Vector4(end.row0[0], end.row0[1], end.row0[2], -(border * scale - smallBorder));
    } else if (scale * oldSize!.width >= 375.w) {
      double offset = border * scale + oldSize!.width * scale - 375.w;
      if (_controller.value.row0[3].abs() <= (border + 12.w) * scale) {
        end.row0 = v.Vector4(end.row0[0], end.row0[1], end.row0[2], -(border * scale));
      } else if (mainOffset.abs() > offset) {
        end.row0 = v.Vector4(end.row0[0], end.row0[1], end.row0[2], -(offset));
      }
    }
    if (oldSize!.height != 400.w) {
      double hBorder = ((400.w - oldSize!.height) / 2) * scale;
      if (_controller.value.row1[3] >= -hBorder || 400.w >= oldSize!.height * scale) {
        if (oldSize!.height * scale < 400.w) {
          double smallBorder = (400.w - oldSize!.height * scale) / 2;
          hBorder -= smallBorder;
        }
        end.row1 = v.Vector4(end.row1[0], end.row1[1], end.row1[2], -hBorder);
      } else if (_controller.value.row1[3] >= -(400.w * scale - hBorder)) {}
    }
    if (end == _controller.value) {
      return;
    }
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _controller.value,
      end: end,
    ).animate(CurvedAnimation(parent: _controllerReset, curve: Curves.easeInOutCubic));
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  var widgetKey = GlobalKey();
  var gifKey = GlobalKey();
  Size? oldSize;
  Rx<Size> gridSize = Size(0, 0).obs;

  TextEditingController controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CbPostCreateScreen, StPostCreateScreen>(buildWhen: (prevState, state) {
      if (state is StPhotoSelect || state is StPhotoChoose) {
        return true;
      }
      if (state is StPostCreateScreenError) return true;
      return false;
    }, builder: (context, state) {
      if (state is StPostCreateScreenError) {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        return Scaffold(
          body: ErrWidget(
            errorCode: state.error.toString() + "\n" + state.message.toString(),
            buttonText: 'Вернуться на главную',
            callback: () {
              navigateToNav();
            },
          ),
        );
      }
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: PjAppBar(
            color: Colors.black,
            title: '',
            bottomLine: false,
            leading: true,
            notBack: true,
            onBack: () {
              if (BlocProvider.of<CbPostCreateScreen>(context).state is StPhotoSelect) {
                ///вот это что-то момжет
                Get.back();
              } else {
                BlocProvider.of<CbPostCreateScreen>(context).emit(StPhotoSelect());
              }
            },
            action: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (BlocProvider.of<CbPostCreateScreen>(context).state is StPhotoSelect) {
                  if (currentImage.path.isEmpty) {
                    return;
                  }
                  controllerDescription.text = '';
                  if (p.extension(currentImage.path) != '.gif') {
                    cropImage();
                  } else {
                    if (gif != null) {
                      BlocProvider.of<CbPostCreateScreen>(context).readyForPublish(null, gif!.width, gif!.height);
                    }
                  }
                } else {
                  String type = p.extension(currentImage.path);
                  List<int> bytes = [];
                  if (type == '.jpg' || type == '.png' || type == '.jpeg') {
                    bytes = type == '.jpg' || type == '.jpeg' ? img.encodeJpg(res!) : img.encodePng(res!);
                    BlocProvider.of<CbPostCreateScreen>(context)
                        .sendPost(res!.width.toDouble(), bytes, type, controllerDescription.text);
                  } else {
                    if (gif != null) {
                      bytes = gif!.file.readAsBytesSync();
                      BlocProvider.of<CbPostCreateScreen>(context)
                          .sendPost(gif!.width.toDouble(), bytes, type, controllerDescription.text);
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(14.w),
                child: Text(
                  BlocProvider.of<CbPostCreateScreen>(context).state is! StPhotoChoose ? 'далее' : 'опубликовать',
                  style: TextStyles.interRegular14.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          body: BlocBuilder<CbPostCreateScreen, StPostCreateScreen>(
            buildWhen: (prevState, state) {
              if (state is StPhotoSelect || state is StPhotoChoose) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is StPostCreateScreenLoading) {
                return const Center(
                  child: Loader(),
                );
              }
              if (state is StPhotoChoose) {
                double scale = 375.w / state.width;
                log(375.w.toString(), name: 'gw');
                log(scale.toString(), name: 's');
                double imageH = state.height.toDouble();
                double imageW = state.width.toDouble();
                bool needToSmall = imageH * scale > (2 * Get.height) / 3;
                if (needToSmall) {
                  double newScale = ((2 * Get.height) / 3) / state.height;
                  imageH = state.height * newScale;
                  imageW = state.width * newScale;
                }
                log(imageW.toString(), name: 'w');
                log(imageH.toString(), name: 'H');
                log(needToSmall.toString(), name: 'N');
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.w),
                            child: SizedBox(
                              height: needToSmall ? Get.height / 2 : null,
                              child: state.img != null
                                  ? RawImage(
                                      image: state.img,
                                      fit: needToSmall ? BoxFit.fitHeight : BoxFit.fitWidth,
                                color: Colors.grey,
                                colorBlendMode: BlendMode.saturation,
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      ),
                                      child: Image.file(currentImage,
                                          fit: needToSmall ? BoxFit.fitHeight : BoxFit.fitWidth),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        TextField(
                          controller: controllerDescription,
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.0.w),
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
              if (state is StPhotoSelect) {
                Widget child;
                if (currentImage.path.isEmpty) {
                  child = Container(
                    child: Center(
                      child: Text(
                        'Для начала, выберите\nфотографию',
                        textAlign: TextAlign.center,
                        style: TextStyles.interMedium20.copyWith(color: PjColors.grey),
                      ),
                    ),
                    // color: Colors.grey.withOpacity(0.5),
                  );
                } else if (p.extension(currentImage.path) == '.gif') {
                  // child = Center(
                  //   child: Image.file(File(currentImage.path)),
                  // );
                  child = Center(
                    child: ColorFiltered(
                      key: gifKey,
                      colorFilter: ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: Image.memory(
                        gif!.data,
                      ),
                    ),
                  );
                } else if (p.extension(currentImage.path) == '.jpg' ||
                    p.extension(currentImage.path) == '.png' ||
                    p.extension(currentImage.path) == '.jpeg') {
                  child = Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.1,
                        maxScale: 2.5,
                        onInteractionEnd: (scale) {
                          _animateResetInitialize();
                        },
                        onInteractionStart: _onInteractionStart,
                        transformationController: _controller,
                        constrained: true,
                        boundaryMargin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.w),
                        child: Container(
                          child: Center(
                            child: Image.file(
                              currentImage,
                              color: Colors.grey,
                              colorBlendMode: BlendMode.saturation,
                              key: widgetKey,
                              frameBuilder: (context, child, frame, f){
                                if(frame == null){
                                  return Loader();
                                }
                                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                  var context = widgetKey.currentContext;
                                  if (context == null) return;
                                  var newSize = context.size;
                                  if (oldSize == newSize) return;
                                  oldSize = newSize;
                                  log(oldSize.toString(), name: 'SIZE');
                                  log(frame.toString(), name: 'FRAME');
                                });
                                return child;
                              },
                            ),
                            // child: RawImage(
                            //   key: widgetKey,
                            //   image: _uiImage,
                            // ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: zoom,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () {
                              _controller.value = Matrix4.identity();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w, bottom: 16.w),
                              child: SvgPicture.asset(
                                PjIcons.scale,
                                width: 32.w,
                                height: 32.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.grey.withOpacity(0.5),
                  );
                }
                return Column(
                  children: [
                    SizedBox(
                      height: 400.w,
                      width: Get.width,
                      child: child,
                    ),
                    // Container(
                    //   height: 42.w,
                    //   width: Get.width,
                    //   color: Colors.black,
                    //   padding: EdgeInsets.all(13.w),
                    //   child: Text(
                    //     'галерея',
                    //     style: TextStyles.interRegular14.copyWith(color: Colors.white),
                    //   ),
                    // ),
                    SizedBox(
                      height: 24.w,
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _button(false, 'Галерея', PjIcons.gallery),
                          SizedBox(
                            width: 11.w,
                          ),
                          _button(true, 'Сделать фото', PjIcons.cameraPost)
                        ],
                      ),
                    ),
                    //Времено забанено из-за оптимизации :(
                    // Expanded(
                    //   child: GridGallery(
                    //     init: data.isEmpty,
                    //     onImageChoose: (File file, Uint8List data) async {
                    //       log(file.path, name: 'FILE');
                    //       if (p.extension(file.path) == '.gif') {
                    //         await _gifProcess(file, data);
                    //       } else {
                    //         await _imageProcess(file, data);
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                );
              }
              if (state is StPostCreateScreenError) {
                return ErrWidget(errorCode: state.error.toString());
              }
              return Container(color: Colors.grey);
            },
          ),
        ),
      );
    });
  }

  void cropImage() async {
    double imageToWidgetScale = oldSize!.width / image!.width;
    double scale = _controller.value.row0[0];
    double hBorder = ((375.w - oldSize!.width) / 2) * scale;
    double vBorder = ((400.w - oldSize!.height) / 2) * scale;
    double xOffset = _controller.value.row0[3];
    double yOffset = _controller.value.row1[3];
    int x = 0;
    int y = 0;
    int width = image!.width;
    int height = image!.height;
    if (oldSize!.width * scale > 375.w) {
      x = (xOffset.abs() - hBorder).toInt();
      x = ((x / scale) / imageToWidgetScale)
          .toInt(); //Не менять toInt на ~/, и в аналогичных ниже. Если заменить при расчетах увеличится погрешность, что приведет к большим потерям пикселей на конце
      width = ((375.w / scale / imageToWidgetScale)).toInt();
    }
    if (oldSize!.height * scale > 400.w) {
      y = (yOffset.abs() - vBorder).toInt();
      y = ((y / scale) / imageToWidgetScale).toInt();
      height = ((400.w / scale / imageToWidgetScale)).toInt();
    }
    // log((x + width).toString(), name: 'countX');
    // log((image!.width).toString(), name: 'orgX');
    // log((y + height).toString(), name: 'countY');
    // log((image!.height).toString(), name: 'orgY');
    img.Image res = img.copyCrop(image!, x, y, width, height);
    ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(res.getBytes(format: img.Format.rgba));
    ui.ImageDescriptor id =
        ui.ImageDescriptor.raw(buffer, height: res.height, width: res.width, pixelFormat: ui.PixelFormat.rgba8888);
    ui.Codec codec = await id.instantiateCodec(targetHeight: res.height, targetWidth: res.width);
    ui.FrameInfo fi = await codec.getNextFrame();
    this.res = res;
    BlocProvider.of<CbPostCreateScreen>(context).readyForPublish(fi.image, fi.image.width, fi.image.height);
  }

  Future<void> _imageProcess(File file, Uint8List data) async {
    img.Image image =
        data.isNotEmpty ? img.decodeImage(List<int>.from(data))! : img.decodeImage(file.readAsBytesSync())!;
    // img.decodeJpg();
    log(image.toString());
    if (image.width > 2000) {
      double scale = 2000 / image.width;
      image = img.copyResize(image, width: (image.width * scale).toInt(), height: (image.height * scale).toInt());
    }
    // image = img.grayscale(image);
    this.image = image;
    // // image = img.copyCrop(image, 0, 0, 300, 400);
    // ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(image.getBytes(format: img.Format.rgba));
    // ui.ImageDescriptor id =
    //     ui.ImageDescriptor.raw(buffer, height: image.height, width: image.width, pixelFormat: ui.PixelFormat.rgba8888);
    // ui.Codec codec = await id.instantiateCodec(targetHeight: image.height, targetWidth: image.width);
    // ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      currentImage = file;
      // _uiImage = fi.image;
      this.data = data;
      _controller.value = Matrix4.identity();
      // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //   var context = widgetKey.currentContext;
      //   if (context == null) return;
      //   var newSize = context.size;
      //   if (oldSize == newSize) return;
      //   oldSize = newSize;
      //   log(oldSize.toString(), name: 'SIZE');
      // });
    });
  }

  Future<void> _gifProcess(File file, Uint8List data) async {
    gifData = data.isNotEmpty ? data : file.readAsBytesSync();
    log('TUT');
    setState(() {
      log('TUT1');
      currentImage = file;
      log(file.path, name: 'FILEPATH');
      // sg.Size gifSize = sg.ImageSizeGetter.getSize(f.FileInput(file));
      if (Platform.isAndroid) {
        sg.Size gifSize = sg.ImageSizeGetter.getSize(f.FileInput(file));
        gif = GifData(data: data, height: gifSize.height, width: gifSize.width, file: file);
        return;
      }
      img.Image? res = img.decodeGif(data);
      log((res == null).toString());
      if (res != null) {
        print(res.width);
        gif = GifData(data: data, height: res.height, width: res.width, file: file);
      }
      // gif = GifData(data: data, height: gifSize.height, width: gifSize.width, file: file);
    });
  }

  Future<void> _getInfo(bool isCamera) async {
    XFile? file;
    PermissionStatus status;
    if (isCamera) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        file = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1500, maxHeight: 1500);
      } else {
        Get.dialog(
          CupertinoAlertDialog(
            title: const Text('Доступ к камере'),
            content: const Text(
                'Чтобы можно было публиковать ваши прекрасные фотографии, необходимо предоставить доступ к "Камера" в настройках и перезагрузить приложение!'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Перейти в "Настройки"'),
                isDestructiveAction: false,
                onPressed: () {
                  PhotoManager.openSetting();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Отмена'),
                isDestructiveAction: true,
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
        );
      }
    } else {
      var result = await PhotoManager.requestPermissionExtend();
      if (result == PermissionState.authorized || result == PermissionState.limited) {
        if (Platform.isAndroid) {
          file = await ImagePicker().pickImage(source: ImageSource.gallery);
        } else {
          file = await ImagePicker()
              .pickImage(source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000);
        }
      } else {
        Get.dialog(
          CupertinoAlertDialog(
            title: const Text('Доступ к фото'),
            content: const Text(
                'Чтобы можно было публиковать ваши прекрасные фотографии, необходимо предоставить доступ к "Фото" в настройках и перезагрузить приложение!\nЕсли же вы не хотите менять свой выбор нажмите "Отмена"!'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Перейти в "Настройки"'),
                isDestructiveAction: false,
                onPressed: () {
                  PhotoManager.openSetting();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Отмена'),
                isDestructiveAction: true,
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          barrierDismissible: false,
        );
      }
    }
    if (file != null) {
      String ext = p.extension(file.path);
      if (ext == '.gif') {
        await _gifProcess(File(file.path), File(file.path).readAsBytesSync());
      } else if(ext == '.jpg' || ext == '.jpeg' || ext == '.heic' || ext == '.png'){
        if (isCamera) {
          GallerySaver.saveImage(file.path);
        }
        String fileExtension = p.extension(file.path).replaceAll('.', '');
        if (fileExtension == 'heic') {
          print('convert to jpeg');
          String? jpegPath = await HeicToJpg.convert(file.path);
          file = XFile(jpegPath!);
          fileExtension = 'jpeg';
        }
        log(file.path, name: 'CONVERT TO JPEG');
        await _imageProcess(File(file.path), File(file.path).readAsBytesSync());
      } else{
        Get.dialog(
          CupertinoAlertDialog(
            title: const Text('Неподдерживаемый формат'),
            content: const Text(
                'Фото такого формата, мы пока что не поддерживаем!'),
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
  }

  Widget _button(bool isCamera, String title, String icon) {
    return GestureDetector(
      onTap: () async {
        await _getInfo(isCamera);
      },
      child: Container(
        width: 170.w,
        height: 46.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: PjColors.blackAnother,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                height: 18.w,
                width: 18.w,
              ),
              SizedBox(
                width: 13.w,
              ),
              Text(
                title,
                style: TextStyles.interRegular14.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GifData {
  Uint8List data;
  int height;
  int width;
  File file;

  GifData({required this.data, required this.height, required this.width, required this.file});
}
