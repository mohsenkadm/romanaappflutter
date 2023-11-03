import 'package:awesome_dialog/awesome_dialog.dart';
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
     // AwesomeDialog(context: context,title: 'Gps',body:const Text('يجب تشغيل الوصول للموقع')).show();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       //     AwesomeDialog(context: context,title: 'Gps',body:const Text('يجب تفعيل صلاحية الوصول للموقع')).show();
      }
    }
  
  if (permission == LocationPermission.deniedForever) {
     //  AwesomeDialog(context: context,title: 'Gps',body:const Text('حدث خطآ اثناء صلاحية الموقع')).show();
  }  
    Position position= await Geolocator.getCurrentPosition();
   latitude.value= position.latitude;
   longitude.value= position.longitude;
  }
 
}