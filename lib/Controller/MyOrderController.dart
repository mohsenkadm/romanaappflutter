import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Model/OrderDetailModel.dart'; 
import 'package:romanaappflutter/Model/OrdersModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 

class MyOrderController extends GetxController {
   
   var items=[].obs;
   
   RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
    Future.delayed(Duration(seconds: 10));
    try{
    //final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getAllCategories));
    //if(response.statusCode==200){
      //final result=json.decode(response.body);
      // var data = result['data'];
      //items.value= data.map((json) => OrdersModel.fromJson(json)).toList();
      // items.add(OrdersModel(orderId: 1, orderNo: 1, orderDate: DateTime.now(),
      //  restaurantId: 1, userId: 1, total: 10, totalDiscount: 10, netAmount: 10,
      //   isCancel: false, isApporve: true, isDone: false, userName: 'test', phone: '09', address: 'address',
      //    functionPoint: 'functionPoint', logo: 'https://source.unsplash.com/user/c_v_r/100x100', restaurantName: 'restaurantName', categoriesName: 'categoriesName'));

      // items.add(OrdersModel(orderId: 1, orderNo: 1, orderDate: DateTime.now(),
      //  restaurantId: 1, userId: 1, total: 10, totalDiscount: 10, netAmount: 10,
      //   isCancel: false, isApporve: false, isDone: false, userName: 'test', phone: '09', address: 'address',
      //    functionPoint: 'functionPoint', logo: 'https://source.unsplash.com/user/c_v_r/100x100', restaurantName: 'restaurantName', categoriesName: 'categoriesName'));

      // items.add(OrdersModel(orderId: 1, orderNo: 1, orderDate: DateTime.now(),
      //  restaurantId: 1, userId: 1, total: 10, totalDiscount: 10, netAmount: 10,
      //   isCancel: true, isApporve: false, isDone: false, userName: 'test', phone: '09', address: 'address',
      //    functionPoint: 'functionPoint', logo: 'https://source.unsplash.com/user/c_v_r/100x100', restaurantName: 'restaurantName', categoriesName: 'categoriesName'));

      // items.add(OrdersModel(orderId: 1, orderNo: 1, orderDate: DateTime.now(),
      //  restaurantId: 1, userId: 1, total: 10, totalDiscount: 10, netAmount: 10,
      //   isCancel: false, isApporve: true, isDone: true, userName: 'test', phone: '09', address: 'address',
      //    functionPoint: 'functionPoint', logo: 'https://source.unsplash.com/user/c_v_r/100x100', restaurantName: 'restaurantName', categoriesName: 'categoriesName'));

   // }
   // else{
     // throw Exception('');
    //}
    }
    finally{
    isloded.value=false; 
    }
  }
}