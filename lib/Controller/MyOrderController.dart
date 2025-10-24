import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 

class MyOrderController extends GetxController {
   
   var itemscurrent=[].obs;
   var itemscancel=[].obs;
   var itemsdone=[].obs;
   
   RxBool isloded=true.obs;

   final ProfileuserController _profileuserController=Get.find<ProfileuserController>();
  @override
  void onInit() {
    super.onInit();
    if(_profileuserController.user.value!=null) {
      fetchData(); // Fetch data when the controller is initialized
    }
  }

 
   final box= GetStorage(); 
  Future<void> fetchData({String searchprod = ""}) async {
    isloded.value=true;
     try{
     int userid= box.read('UserId')??0;
     if(userid==0)return;
     var s=searchprod.isEmpty?'/ ,'+userid.toString():'/'+searchprod+','+userid.toString();
    
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getMyOrder+s));
    if(response.statusCode==200){
      final result=json.decode(response.body);
        if (result['success'] == false) {

    isloded.value=false; 
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);  
        }
      var data = result['data'];
      List<dynamic> item= data.map((json) => OrdersModel.fromJson(json)).toList(); 
      itemscurrent.value=item.where((e)=>e.isDone==false && e.isCancel==false).toList();
      itemscancel.value=item.where((e) => e.isCancel==true).toList();
      itemsdone.value=item.where((e) => e.isDone == true ).toList();
   }
   else{
      ErrorMessage.error;
    }
    
    }
    catch(ex){
      ErrorMessage.error;
    }
    finally{
    isloded.value=false; 
    }
  }
  
}