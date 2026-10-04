import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/NetworkController.dart';
import 'package:romanaappflutter/Controller/ProductController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/RestourentController.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/Controller/notificationController.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/SupportPhoneController.dart';

class dependencyinjection {
 
  static void onInit(){
   Get.put<NetworkController>(NetworkController(),permanent: true);
   Get.put<SupportPhoneController>(SupportPhoneController(), permanent: true);
   Get.put<ProfileuserController>(ProfileuserController());
   Get.put<MyOrderController>(MyOrderController());
    Get.put<RestourentController>(RestourentController());
    Get.put<ProductController>(ProductController());
    Get.put<determinePositionLocation>(determinePositionLocation());
    Get.put<ShoppingCardController>(ShoppingCardController());
    Get.put<notificationController>(notificationController());
    Get.put<AppBadgeController>(AppBadgeController());
  }
}