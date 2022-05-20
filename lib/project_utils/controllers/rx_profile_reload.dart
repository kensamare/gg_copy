
import 'package:get/get.dart';

class RxProfileReload extends GetxController{
  Rx<bool> isReload = false.obs;

 void  setReload(bool flag){
   isReload.value = flag;
   update();
 }
}