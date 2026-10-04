import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Service/order_api_http.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/StarsController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 
import 'package:romanaappflutter/views/PostOrderRatingView.dart';

class MyOrderController extends GetxController {
  /// يضمن وجود الكنترولر حتى لو فُتحت شاشة قبل MainApp.
  static MyOrderController get instance {
    if (Get.isRegistered<MyOrderController>()) {
      return Get.find<MyOrderController>();
    }
    return Get.put(MyOrderController());
  }

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
    
    final response=await OrderApiHttp.get(Uri.https(AppLink.apiUrl,AppLink.getMyOrder+s));
    if(response.statusCode==200){
      final result=json.decode(response.body);
        if (result['success'] == false) {

    isloded.value=false; 
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);  
        }
      var data = result['data'];
      List<OrdersModel> item = data
          .map<OrdersModel>((json) => OrdersModel.fromJson(json))
          .toList();
      bool isCancelled(OrdersModel e) =>
          e.isCancel == true || e.statusCode == 9;
      bool isCompleted(OrdersModel e) =>
          e.isDone == true || (e.statusCode != null && e.statusCode! >= 7 && e.statusCode != 9);

      itemscancel.value = item.where(isCancelled).toList();
      itemsdone.value =
          item.where((e) => !isCancelled(e) && isCompleted(e)).toList();
      itemscurrent.value = item
          .where((e) => !isCancelled(e) && !isCompleted(e))
          .toList();
      _maybePromptRatingForCompleted(
          List<OrdersModel>.from(itemsdone));
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

  /// When an order moves to Completed and the user hasn't seen the rating
  /// screen yet, show it once. Tracked locally so we don't nag.
  void _maybePromptRatingForCompleted(List<OrdersModel> done) {
    final box = GetStorage();
    final stars = Get.isRegistered<StarsController>()
        ? Get.find<StarsController>()
        : Get.put(StarsController());
    for (final o in done) {
      final id = o.orderId;
      if (id == null) continue;
      final promptedKey = 'rating_prompted_$id';
      if (box.read(promptedKey) == true) continue;
      // Only prompt if at least one rating is still pending.
      if (stars.hasRatedFood(id) && stars.hasRatedDriver(id)) continue;
      box.write(promptedKey, true);
      // Defer to next frame so navigation context is ready.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context == null) return;
        Get.to(() => PostOrderRatingView(orderId: id),
            duration: const Duration(milliseconds: 400),
            transition: Transition.downToUp);
      });
      break; // prompt one at a time
    }
  }
  
}