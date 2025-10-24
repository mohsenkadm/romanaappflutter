import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/ErrorMessage.dart'; 
import 'package:romanaappflutter/linkapi.dart'; 

import '../Model/OrderDetailModel.dart'; 

class OrderDetailsController extends GetxController {
   
  RxDouble netAmount=0.0.obs;
  RxDouble totalprice=0.0.obs;
  RxDouble discountprice=0.0.obs; 
   var itemscurrent=[].obs; 
   String OrderId='0';
   RxBool isloded=true.obs;
  @override
  void onInit() async{
     var data = Get.arguments;
   if(data!=null){
    OrderId=data[0].toString();
    await  fetchData(); 
     }
    super.onInit();
    
  }
 
  Future<void> fetchData() async {
    isloded.value=true;
     try{ 
      final Map<String, String> _queryParameters = <String, String>{
              'Id': OrderId,
            };
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getOrdersWithDetailAll,_queryParameters));
    if(response.statusCode==200){
      final result=json.decode(response.body);
      var data = result['data'];
      itemscurrent.value= data.map((json) => OrderDetailModel.fromJson(json)).toList(); 
       if(itemscurrent.isNotEmpty) {
         SumPrice();
       }
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

      update();
  } 
   Future<void> SumPrice() async{
    try{
      netAmount.value= 0; 
    totalprice.value= 0;
    discountprice.value= 0;
    discountprice.value= itemscurrent.value.first.totalDiscount; 
                
    netAmount.value=itemscurrent.value.first.netAmount;  
    totalprice.value= itemscurrent.value.first.total;
    }
    finally{ 
    }
  }
}