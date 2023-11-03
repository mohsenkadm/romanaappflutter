import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class NetworkController extends GetxController{
  final Connectivity _connecttivicty=Connectivity();
  
  @override
  void onInit(){
    super.onInit();
    _connecttivicty.onConnectivityChanged.listen(_updateConnectionstatus);
  }
  void _updateConnectionstatus(ConnectivityResult result)
  {
    if(result==ConnectivityResult.none)
    {
      Get.rawSnackbar(
       messageText: const Text('لا يوجد اتصال بلانترنت',
       style:  TextStyle(color: Colors.white, fontSize: 14)
       ),
       isDismissible: false,
       snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red[400]!,
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
      icon:const Icon(Icons.wifi_off,color: Colors.white, size: 35,)
      );
    }
    else { 
      if(Get.isSnackbarOpen)
      {
        Get.closeCurrentSnackbar();
        Get.rawSnackbar(
        messageText: const Text('عاد الآتصال الى الانترنت',
        style:  TextStyle(color: Colors.white, fontSize: 14)
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[400]!,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
        icon:const Icon(Icons.wifi,color: Colors.white, size: 35,)
        );
      }
    }
  }
}