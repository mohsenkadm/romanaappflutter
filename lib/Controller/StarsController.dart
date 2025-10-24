import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/StarsModel.dart';  
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/linkapi.dart';

class StarsController extends GetxController {
    
   RxBool isloded=false.obs;
   RxDouble starCount=3.0.obs;
  final commentController=TextEditingController(); 
  
  @override
  void onInit() {
    super.onInit();
    starCount.value=3.0;
  }
  
  

  Future<void> sendStars() async{
    if(isloded.value) return;
    isloded.value=true;
    try { 
      var data = Get.arguments;
   if(data!=null){
    var resId=data[0];
     StarsModel stars=StarsModel(starsId: 0, 
      starsCount: starCount.value.toInt(),
      restaurantId: int.tryParse(resId), 
      
      comments: commentController.text);
  var body=jsonEncode(stars.toJson());
  var response = await http.post(
      Uri.https(AppLink.apiUrl,AppLink.sendStars), 
      headers: {'Content-Type':'application/json'},
      body:body
      );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    if(data['success']==false){ 
    isloded.value=false; 
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
    return;
     }
    else{  
      Get.back(); 
     ErrorMessage.SnackMessage('تم تقييم بنجاح',Colors.green[400]!); 
    }
  } else { 
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
     return;
  }
  }
} 
catch (ex) {
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
     return;
} 
   finally{
    isloded.value=false; 
   }
  }

  
}