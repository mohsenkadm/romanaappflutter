import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/SubCategoriesModel.dart';
import 'package:romanaappflutter/linkapi.dart';

class RestaourantProfileController extends GetxController{

   RxBool isloded=true.obs; 
   RxBool islodedprod=false.obs; 
   RxBool islodedsub=true.obs; 
   String ResId='0';
    final item=RestaurantModel().obs;
  var itemprod=[].obs; 
  var itemSubCategory=[].obs; 
  
  @override
  void onInit() async{
      var data = Get.arguments;
   if(data!=null){
    ResId=data[0].toString();
    await  fetchData(); 
     }
     super.onInit();
  }
 void OnClose()
 {
      if(ListItemCard.itemscard.isNotEmpty){
          AwesomeDialog(
                  buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                  context: Get.context!,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide, 
                  title:'حذف السلة',
                  reverseBtnOrder: true,
                  showCloseIcon: true,
                  btnOkText: 'نعم',
                  btnCancelText: 'الغاء',
                  btnOkIcon: Icons.check_circle,
                  btnCancelIcon: Icons.cancel,
                  btnOkOnPress: () {
                    ListItemCard.itemscard.clear(); 
                    Get.back();
                  },
                  btnCancelOnPress: () { 
                    
                  },
                  desc: 'اذا قمت الخروج من المطعم سيتم حذف السلة هل تريد حذفها؟')
              .show();
      } 
      else{
        Get.back();
      }
      
 }

  Future<void> fetchData() async {  
    isloded.value=true;
      try{
         final Map<String, String> _queryParameters = <String, String>{
              'Id': ResId,
            };
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantById,_queryParameters));
    if(response.statusCode==200){
      final result=json.decode(response.body);
       var data = result['data'];
      
       RestaurantModel restaurantModel = RestaurantModel.fromJson(data);
     item.value=restaurantModel; 
     fetchDataSubCategory(); 
    }
    else{
      ErrorMessage.error();
    }
    }
    catch(ex){
      ErrorMessage.error();
    }
    finally{
    isloded.value=false; 
    }
  }
 
  var SubIdActive=0.obs;
void ChooseSubCategory(value)
   { 
    SubIdActive.value=value;
     fetchDataProductByRestaurantId(SubId: value);  
    update();
   }
  Future<void> fetchDataSubCategory() async {  
    islodedsub.value=true;  
      try{  
             final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantSubCategories+ResId));
    if(response.statusCode==200){
      final result=json.decode(response.body);
      if(result['success']==false){ 
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
      islodedsub.value=false; 
      return;
      }
      itemSubCategory.value.clear();
       var data = result['data'];
      // itemSubCategory.value.add(SubCategoriesModel(SubCategoriesId: 0, SubCategoriesName: 'الكل'));
      itemSubCategory.value.addAll( data.map((json) => SubCategoriesModel.fromJson(json)).toList());
 if(itemSubCategory.value.isNotEmpty){
 SubIdActive.value=itemSubCategory[0].SubCategoriesId;
fetchDataProductByRestaurantId(SubId: SubIdActive.value) ; }
    }
    else{
      ErrorMessage.error();
    }
    }
    finally{ 
       islodedsub.value=false; 
    }
  }
  
    Future<void> fetchDataProductByRestaurantId({required int SubId,String searchprod = ""}) async {   
   islodedprod.value=true;
      try{  
         var s=searchprod.isEmpty?' ':searchprod+'';
     
        final response=await http.get(Uri.https(AppLink.apiUrl,'${AppLink.getProductsByRestaurantId}$ResId,$SubId,$s'));
    if(response.statusCode==200){
      final result=json.decode(response.body); 
      if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);  
        }
       var data = result['data'];
      itemprod.value= data.map((json) => ProductsModel.fromJson(json)).toList();
    }
    else{
      ErrorMessage.error();
    } 
    }
    catch (ex){
      ErrorMessage.error();
    }
    finally{ 
      islodedprod.value=false;
    }
  }
   
}