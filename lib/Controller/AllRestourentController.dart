import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/Constant/restaurant_location_query.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/linkapi.dart';

class AllRestourentController extends GetxController {
  var itemsresAll = [].obs;
 
  RxBool islodedGetAll = true.obs;
  var cityvalue=0.obs;
  final box= GetStorage();  
  final determinePositionLocation locationService = Get.find();
  @override
  void onInit() async {
    await locationService.getCurrentLocation();// Fetch data when the controller is initialized
    var data = Get.arguments;
     if(data!=null){
    await fetchDataGetAll(data[0].toString());
     }
    super.onInit();
  }
   void ChooseCategory(categoryid) async => await  fetchDataGetAll(categoryid.toString());
  Future<void> fetchDataGetAll(categoryid) async {
    islodedGetAll.value=true;
    try { 
      if (!LocationStorage.coverageVerified) {
        islodedGetAll.value = false;
        return;
      }
       final response = await http.get(Uri.https(
          AppLink.apiUrl,
          AppLink.getRestaurantByLocation,
          RestaurantLocationQuery.build()));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            var data = result['data'] as List? ?? [];
            final all = data.map((json) => RestaurantModel.fromJson(json)).toList();
            // Filter by category client-side (categoryid == 0 means all)
            final cid = int.tryParse(categoryid.toString()) ?? 0;
            itemsresAll.value = cid == 0
                ? all
                : all.where((r) => r.categoriesId == cid).toList();
              
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
