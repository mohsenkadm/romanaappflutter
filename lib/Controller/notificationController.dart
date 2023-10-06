import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Model/NotifModel.dart'; 
import '../linkapi.dart'; 

// ignore: camel_case_types
class notificationController extends GetxController{

   var items=[].obs;
  RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }

  
  Future<void> fetchData() async {
    try{
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getNotification));
    if(response.statusCode==200){
      final result=json.decode(response.body);
       var data = result['data'];
      items.value= data.map((json) => NotifModel.fromJson(json)).toList();
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