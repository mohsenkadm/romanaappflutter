import 'package:get/get.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Model/CarouselModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 
class MainController extends GetxController {

   RxBool isloded=true.obs;
   var itemsCarousel=[].obs;
  var currentIndex = 0.obs; 
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataCarousel(); // Fetch data when the controller is initialized
  }
  Future<void> fetchDataCarousel() async {
    try{
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getAllCarousel));
    if(response.statusCode==200){
      final result=json.decode(response.body);
       var data = result['data'];
      itemsCarousel.value= data.map((json) => CarouselModel.fromJson(json)).toList();
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
