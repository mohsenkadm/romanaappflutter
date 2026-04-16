import 'dart:convert'; 
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
               currentSelectedItem.value =  box.read("selectcity");
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
