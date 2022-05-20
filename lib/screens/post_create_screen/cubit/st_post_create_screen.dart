import 'dart:ui';


abstract class StPostCreateScreen{}

class StPostCreateScreenInit extends StPostCreateScreen{}

class StPostCreateScreenLoaded extends StPostCreateScreen{}

class StPostCreateScreenLoading extends StPostCreateScreen{}

class StPostCreateScreenNoAuthError extends StPostCreateScreen{}

class StPhotoChoose extends StPostCreateScreen{
  final Image? img;
  final int width;
  final int height;

  StPhotoChoose({this.img, required this.width, required this.height});
}

class StPhotoSelect extends StPostCreateScreen{}

class StPostCreateScreenNoInternetError extends StPostCreateScreen {}

class StPostCreateScreenError extends StPostCreateScreen{
  final int? error;
  final String? message;
  StPostCreateScreenError({this.error,this.message});
}
    