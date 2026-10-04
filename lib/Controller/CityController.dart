import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/CityModel.dart';
import 'package:romanaappflutter/Model/CountriesModel.dart';  
import 'package:romanaappflutter/linkapi.dart';

class CityController extends GetxController {
  var itemscityAll = [].obs; 
  var itemsCountriesAll = [].obs; 
  final box= GetStorage();  
  RxBool isloded = true.obs;
   var currentSelectedItem="".obs; 
   var currentSelected2Item="".obs; 
  @override
  void onInit() async {
     await fetchDataGetCountriesAll();  
   currentSelected2Item.value =  box.read("selectCountries");
   update();
    super.onInit();
  }
   void ChooseCity(value)
   {
      currentSelectedItem.value = value;  
      box.write("selectcity", value);
   }
   void ChooseCountries(value)
   {
      currentSelected2Item.value = value;  
      getcityGetByCountriesId(value);
      box.write("selectCountries", value);
   }
   void savecity()
   {
      box.write("selectcity", currentSelectedItem.value);
            box.write("selectCountries", currentSelected2Item.value);
              ErrorMessage.SnackMessage(
              'تم الحفظ بنجاح', Colors.green[400]!);
             // Auto-close the location screen and return to the previous screen.
             if (Get.key.currentState?.canPop() ?? false) {
               navigator?.pop();
             }
   }
  Future<void> getcityGetByCountriesId(String countryid) async {
    isloded.value=true;
    try {
        final Map<String, String> _queryParameters = <String, String>{
        'CountriesId': countryid,
      };
       final response = await http.get(Uri.https(
          AppLink.apiUrl,
          AppLink.getcityGetByCountriesId,_queryParameters));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            var data = result['data'];
            itemscityAll.assignAll(
                data.map((json) => CityModel.fromJson(json)));
            // Validate stored city value against the fresh list.
            final fetchedCityIds = itemscityAll
                .map((c) => c.CityId.toString())
                .toSet();
            final savedCity = box.read("selectcity")?.toString() ?? '';
            currentSelectedItem.value =
                fetchedCityIds.contains(savedCity) ? savedCity : '';
            update();
          } else { 
          ErrorMessage.error;
          }  
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
  }

  Future<void> fetchDataGetCountriesAll() async {
    isloded.value=true;
    try {
       final response = await http.get(Uri.https(
          AppLink.apiUrl,
          AppLink.getCountries));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            var data = result['data'];
            itemsCountriesAll.assignAll(
                data.map((json) => CountriesModel.fromJson(json)));
            // Validate stored country value against the fresh list.
            final fetchedIds = itemsCountriesAll
                .map((c) => c.CountriesId.toString())
                .toSet();
            if (!fetchedIds.contains(currentSelected2Item.value)) {
              currentSelected2Item.value = '';
            }
            update();
          } else { 
          ErrorMessage.error;
          }  
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
  }
}
