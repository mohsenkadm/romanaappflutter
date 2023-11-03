import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/linkapi.dart'; 

class RestourentController extends GetxController {
   
   var itemsres=[].obs;
   var itemsresAll=[].obs;
   
   RxBool isloded=true.obs;
   RxBool islodedGetAll=true.obs;

  final determinePositionLocation locationService = Get.find();
  @override
  void onInit() { 
    super.onInit();
    fetchDataTop(); // Fetch data when the controller is initialized
    fetchDataGetAll();
  }


  Future<void> fetchDataTop() async { 
   await  Future.delayed(Duration(seconds: 3)); 
      try{  
        itemsres.add(RestaurantModel(restaurantId: 0, name: 'name', details: 'details',
        address: 'address', logo: 'https://source.unsplash.com/user/c_v_r/100x100', background: 'https://source.unsplash.com/user/c_v_r/500x200', phone: '0750',
         lat: 'lat', long: 'long', code: 'code', whatsapp: 'whatsapp', starCount:50, isClosed: false,
          isStars: true, minimumPrice: 0, areaname: 'areaname', categoriesId: 1, categoriesName: ''));
        itemsres.add(RestaurantModel(restaurantId: 0, name: 'name', details: 'details',
        address: 'address', logo: 'https://source.unsplash.com/user/c_v_r/100x100', background: 'https://source.unsplash.com/user/c_v_r/500x200', phone: '0750',
         lat: 'lat', long: 'long', code: 'code', whatsapp: 'whatsapp', starCount:50, isClosed: false,
          isStars: true, minimumPrice: 0, areaname: 'areaname', categoriesId: 1, categoriesName: ''));
        itemsres.add(RestaurantModel(restaurantId: 0, name: 'name', details: 'details',
        address: 'address', logo: 'https://source.unsplash.com/user/c_v_r/100x100', background: 'https://source.unsplash.com/user/c_v_r/500x200', phone: '0750',
         lat: 'lat', long: 'long', code: 'code', whatsapp: 'whatsapp', starCount:50, isClosed: false,
          isStars: true, minimumPrice: 0, areaname: 'areaname', categoriesId: 1, categoriesName: ''));
        itemsres.add(RestaurantModel(restaurantId: 0, name: 'name', details: 'details',
        address: 'address', logo: 'https://source.unsplash.com/user/c_v_r/100x100', background: 'https://source.unsplash.com/user/c_v_r/500x200', phone: '0750',
         lat: 'lat', long: 'long', code: 'code', whatsapp: 'whatsapp', starCount:50, isClosed: false,
          isStars: true, minimumPrice: 0, areaname: 'areaname', categoriesId: 1, categoriesName: ''));
        //      final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantTopAllForApp));
    // if(response.statusCode==200){
    //   final result=json.decode(response.body);
    //    var data = result['data'];
    //   itemsres.value= data.map((json) => RestaurantModel.fromJson(json)).toList();
    // }
    // else{
    //   throw Exception('');
    // }
    }
    finally{
    isloded.value=false; 
    }
  }

  Future<void> fetchDataGetAll() async {
      try{ 
    //      final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantAllForApp));
    // if(response.statusCode==200){
    //   final result=json.decode(response.body);
    //    var data = result['data'];
    //   itemsresAll.value= data.map((json) => RestaurantModel.fromJson(json)).toList();
    // }
    // else{
    //   throw Exception('');
    // }
    }
    finally{
    islodedGetAll.value=false; 
    }
  }
}