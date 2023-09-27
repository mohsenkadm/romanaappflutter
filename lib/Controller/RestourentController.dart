import 'package:get/get.dart'; 

class RestourentController extends GetxController {
   
   var itemscategories=[].obs;
   
   RxBool isloded=false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
    
    isloded.value=true; 
    isloded.value=false;
  }
}