import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/CarouselModel.dart';  
import 'package:romanaappflutter/linkapi.dart'; 
class MainController extends GetxController {

   RxBool isloded=true.obs;
   var itemsCarousel=[].obs;
  var currentIndex = 0.obs; 
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

   final box= GetStorage(); 
  @override
  void onInit() {
    super.onInit();
    fetchDataCarousel(); // Fetch data when the controller is initialized
  }
  Future<void> fetchDataCarousel() async {
    try{
        String countryid= box.read("selectCountries") ?? "0";
   final Map<String, String> _queryParameters = <String, String>{
        'CountryId': countryid,
        'AppType': AppLink.carouselAppType.toString(),
      };
    final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getAllCarousel,_queryParameters));
    if(response.statusCode==200){
      final result=json.decode(response.body);
       var data = result['data'];
      itemsCarousel.value= data.map((json) => CarouselModel.fromJson(json)).toList();
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
}
