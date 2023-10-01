import 'package:get/get.dart'; 

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
    isloded.value=true;
    await Future.delayed(const Duration(seconds: 2));
     isloded.value=false;
  }
}