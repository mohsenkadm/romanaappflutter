
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class determinePositionLocation extends GetxService {
   RxDouble latitude = 0.0.obs; 
  RxDouble longitude =0.0.obs; 
  
    Future  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission; 
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
       Get.rawSnackbar(
        messageText: const Text('يجب تشغيل الوصول للموقع',
        style:  TextStyle(color: Colors.white, fontSize: 14)
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[400]!,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
        icon:const Icon(Icons.location_on,color: Colors.white, size: 35,)
        );
      permission = await Geolocator.requestPermission();
        return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
         Get.rawSnackbar(
        messageText: const Text('يجب تفعيل صلاحية الوصول للموقع',
        style:  TextStyle(color: Colors.white, fontSize: 14)
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[400]!,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
        icon:const Icon(Icons.location_on,color: Colors.white, size: 35,)
        );
        return;
        }
    }
  
  if (permission == LocationPermission.deniedForever) {
      Get.rawSnackbar(
        messageText: const Text('حدث خطآ اثناء عملية جلب صلاحيات الموقع',
        style:  TextStyle(color: Colors.white, fontSize: 14)
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[400]!,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
        icon:const Icon(Icons.location_on,color: Colors.white, size: 35,)
        ); 
      permission = await Geolocator.requestPermission();
        return;
   }  
    Position position= await Geolocator.getCurrentPosition();
   latitude.value= position.latitude;
   longitude.value= position.longitude;
    
  }
 
}