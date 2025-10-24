import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/ChooseLocation.dart';

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
   cityvalue.value = int.parse(box.read("selectcity") ?? "0");
   if(cityvalue.value==0){
    AwesomeDialog(
                  buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                  context: Get.context!,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title: 'تحديد المنطقة',
                  reverseBtnOrder: true,
                  showCloseIcon: true,
                  btnOkText: 'نعم',
                  btnCancelText: 'الغاء',
                  btnOkIcon: Icons.check_circle,
                  btnCancelIcon: Icons.cancel,
                  btnOkOnPress: () {
                   Get.to(const ChooseLocation());
                  }, 
                  desc:'يجب تحديد موقعك الحالي')
              .show();
              return;
   }
      var latitude = locationService.latitude.value.toString();
      var longitude = locationService.longitude.value.toString();
       final response = await http.get(Uri.https(
          AppLink.apiUrl,
          '${AppLink.getRestaurantAllForApp +
              '/%,'+categoryid},$longitude,$latitude,${cityvalue.value}'));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
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
