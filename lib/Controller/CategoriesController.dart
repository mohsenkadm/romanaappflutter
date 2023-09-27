import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Model/CategoriesModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 

class CategoriesController extends GetxController {
   
   var itemscategories=[].obs;
   
   RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
    try{
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getAllCategories));
    if(response.statusCode==200){
      final result=json.decode(response.body);
       var data = result['data'];
      itemscategories.value= data.map((json) => CategoriesModel.fromJson(json)).toList();
    }
    else{
      throw Exception('');
    }
    }
    finally{
    isloded.value=false; 
    }
  }
}