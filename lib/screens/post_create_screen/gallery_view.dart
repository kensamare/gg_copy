import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:gg_copy/project_utils/pj_icons.dart';
import 'package:gg_copy/project_widgets/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class GridGallery extends StatefulWidget {
  final ScrollController? scrollCtr;
  final bool init;
  final Function(File file, Uint8List data)? onImageChoose;

  const GridGallery({
    Key? key,
    this.scrollCtr,
    this.init = true,
    this.onImageChoose,
  }) : super(key: key);

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;
  bool isLoading = false;

  bool canShow = false;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia(init: widget.init);
  }

  _handleScrollEvent(ScrollNotification scroll) {
    // if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.1 && scroll.metrics.maxScrollExtent != 0) {
    //   if (currentPage != lastPage) {
    //     _fetchNewMedia();
    //   }
    // }
  }

  _fetchNewMedia({bool init = false}) async {
    if (isLoading) return;
    isLoading = true;
    lastPage = currentPage;
    var result;
    result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized || result == PermissionState.limited) {
      canShow = true;
    }
    if (canShow) {
      // success
//load the album list
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media = await albums[0].getAssetListPaged(page: currentPage, size: 60); //preloading files
      List<Widget> temp = [];
      int index = -1;
      int i = 0;
      for (var asset in media) {
        if (asset.type == AssetType.image) {
          if (index == -1) {
            index = i;
          }
          temp.add(
            FutureBuilder(
              future: asset.thumbnailDataWithSize(ThumbnailSize(1500.toInt(), 1500.toInt())),
              //resolution of thumbnail
              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () async {
                              if (widget.onImageChoose != null) {
                                widget.onImageChoose!((await asset.file)!, snapshot.data!);
                              }
                            },
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // if (asset.type == AssetType.video)
                        //   Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: Padding(
                        //       padding: EdgeInsets.only(right: 5, bottom: 5),
                        //       child: Icon(
                        //         Icons.videocam,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        }
        i++;
      }
        if (init && media.isNotEmpty && widget.onImageChoose != null) {
          widget.onImageChoose!((await media[index].file)!, Uint8List(0));
        }
      setState(() {
        isLoading = false;
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
                  Get.back();
                },
              )
            ],
          ),
          barrierDismissible: false,
        );
      });

      // PhotoManager.openSetting();
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onLoading() async {
    await _fetchNewMedia();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        // if(scroll is ScrollEndNotification) {
        //   _fetchNewMedia();
        //  // _handleScrollEvent(scroll);
        // }
        return false;
      },
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: false,
        controller: _refreshController,
        onLoading: _onLoading,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            if (mode == LoadStatus.loading) {
              return Container(
                height: 55.0.w,
                child: Center(child: Loader()),
              );
            }
            return Container();
          },
        ),
        child: GridView.builder(
            controller: widget.scrollCtr,
            itemCount: _mediaList.length + 1,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Container(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          PermissionStatus status = await Permission.camera.request();
                          print(status);
                          if (status.isGranted) {
                            XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.camera, maxHeight: 1200, maxWidth: 1200);
                            if (image != null) {
                              GallerySaver.saveImage(image.path);
                              Uint8List bytes = await image.readAsBytes();
                              File img = File(image.path);
                              setState(() {
                                _mediaList.insert(
                                    0,
                                    Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (widget.onImageChoose != null) {
                                                  widget.onImageChoose!(img, bytes);
                                                }
                                              },
                                              child: Image.file(
                                                img,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // if (asset.type == AssetType.video)
                                          //   Align(
                                          //     alignment: Alignment.bottomRight,
                                          //     child: Padding(
                                          //       padding: EdgeInsets.only(right: 5, bottom: 5),
                                          //       child: Icon(
                                          //         Icons.videocam,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      ),
                                    ));
                              });
                              widget.onImageChoose!(img, bytes);
                            }
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
                          // if(widget.onImageChoose != null){
                          //   widget.onImageChoose!((await asset.file)!, snapshot.data!);
                          // }
                        },
                        child: Container(
                            padding: EdgeInsets.only(bottom: 30.w, left: 30.w, right: 20.w, top: 20.w),
                            child: SvgPicture.asset(
                              PjIcons.camera,
                              width: 20.w,
                              height: 20.w,
                            )),
                      ),
                    )
                  : _mediaList[index - 1];
            }),
      ),
    );
  }
}
