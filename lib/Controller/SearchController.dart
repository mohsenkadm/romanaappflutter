import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart'; 
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/linkapi.dart'; 

class Search_Controller extends GetxController {
  var itemprod = [].obs;
  var itemsresAll = [].obs;

  RxBool isloded = true.obs;
  RxBool islodedGetAll = true.obs;
  
  @override
  void onInit() async { // Fetch data when the controller is initialized
    await fetchDataGetAll();
    await fetchDataProduct();
    super.onInit();
  }
  Future<void> fetchDataProduct({String searchprod = ""}) async {
   
      isloded.value = true;
    try {
      var s=searchprod.isEmpty?' ,1':searchprod+',1';
      final response = await http.get(
          Uri.https(AppLink.apiUrl, AppLink.getProductsallBySearch + s));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);  
        }
        var data = result['data'];
        itemprod.value = data.map((json) => ProductsModel.fromJson(json)).toList();
      } else {
        ErrorMessage.error;
      }  
    } finally { isloded.value = false;}
  }
 

  Future<void> fetchDataGetAll({String searchprod = ""}) async {

      islodedGetAll.value = true;
    try { 
      var s=searchprod.isEmpty?'/ ,0,0.0,0.0,0':'/'+searchprod+',0,0.0,0.0,0';
    
      final response = await http.get(Uri.https(
          AppLink.apiUrl,
          AppLink.getRestaurantAllForApp +
              s));
      if (response.statusCode == 200) {
        final result = json.decode(response.body); if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);  
        }
        var data = result['data'];
        itemsresAll.value =
            data.map((json) => RestaurantModel.fromJson(json)).toList();
      } else {
       ErrorMessage.error;
      }
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      islodedGetAll.value = false;
    }
  }
}
