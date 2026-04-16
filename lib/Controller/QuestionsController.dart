import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Model/QuestionsModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 

class QuestionsController extends GetxController {
   
   var itemsQuestions=[].obs;
   
   RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
    try{
      isloded.value=true;
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getQuestions));
    if(response.statusCode==200){
      isloded.value=false;
      final result=json.decode(response.body);
       var data = result['data'];
      itemsQuestions.value= data.map((json) => QuestionsModel.fromJson(json)).toList();
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