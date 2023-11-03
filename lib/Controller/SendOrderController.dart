import 'dart:convert';

import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/linkapi.dart'; 
import 'package:http/http.dart' as http;

import '../Model/PromoCodeModel.dart';
class SendOrderController extends GetxController{
  RxBool isloded=true.obs;
  RxDouble netAmount=0.0.obs;
  RxDouble totalprice=0.0.obs;
  RxDouble discount=0.0.obs;  
  @override
  void onInit() {
    super.onInit();  
     SumPrice();
  }

  Future<void> getpromocode() async {
    try{
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getPromoCode));
    if(response.statusCode==200){
      final result=json.decode(response.body);
      var data = result['data'];
      var promocode= data.map((json) => PromoCodeModel.fromJson(json)).toList();
      if(promocode!=null){
         discount.value=0;
         SumPrice();
         update();
      }
    }
    else{
      throw Exception('');
    }
    }
    finally{
    isloded.value=false; 
    }
  }

  Future<void> SumPrice() async{
    try{
      netAmount.value= 0;
    discount.value= 0;
    totalprice.value= 0;
    netAmount.value= ListItemCard.itemscard.map((item) => item.price * item.count)
               .reduce((ele1, ele2) => ele1 + ele2)-discount.value; 
    discount.value= 0;
    totalprice.value= ListItemCard.itemscard.map((item) => item.price * item.count)
               .reduce((ele1, ele2) => ele1 + ele2);
    } 
    finally{ 
    }
  }
     
}