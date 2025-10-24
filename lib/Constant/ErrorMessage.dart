import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorMessage{
  static void error() {
    Get.rawSnackbar(
     messageText: const Text('حدث خطا اثناء عملية جلب البيانات',
     style:  TextStyle(color: Colors.white, fontSize: 14)
     ),
     isDismissible: true,
     snackPosition: SnackPosition.TOP,
     duration: const Duration(seconds: 2),
     backgroundColor: Colors.red[400]!,
     margin: EdgeInsets.zero,
     snackStyle: SnackStyle.FLOATING,
     icon:const Icon(Icons.error,color: Colors.white, size: 35,)
     );
  }
  static  void SnackMessage(msg,Color cs) {
    Get.rawSnackbar(
         messageText:  Text(msg,
         style:  const TextStyle(color: Colors.white, fontSize: 14)
         ),
         isDismissible: true,
         snackPosition: SnackPosition.TOP,
         duration: const Duration(seconds: 2),
         backgroundColor: cs,
         margin: EdgeInsets.zero,
         snackStyle: SnackStyle.FLOATING,
         icon:const Icon(Icons.error,color: Colors.white, size: 35,)
         );
  }
}