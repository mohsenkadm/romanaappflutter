import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/NetworkController.dart';

class dependencyinjection {
 
  static void onInit(){
   Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}